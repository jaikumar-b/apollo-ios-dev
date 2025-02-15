import XCTest
import Nimble
@testable import ApolloCodegenLib
import ApolloCodegenInternalTestHelpers
import ApolloAPI
import GraphQLCompiler

class CustomScalarTemplateTests: XCTestCase {
  // Since the base protocol is actually used, Use TemplateRenderer. This can be confirmed that no unintended implementation is using.
  var subject: (any TemplateRenderer)!

  // MARK: Helpers

  override func tearDown() {
    subject = nil

    super.tearDown()
  }

  private func buildSubject(
    name: String = "MyCustomScalar",
    customName: String? = nil,
    config: ApolloCodegenConfiguration = .mock()
  ) {
    let scalarType = GraphQLScalarType.mock(name: name)
    scalarType.name.customName = customName
    
    subject = CustomScalarTemplate(
      graphqlScalar: scalarType,
      config: ApolloCodegen.ConfigurationContext(config: config)
    )
  }

  private func buildSubject(
    type: GraphQLScalarType,
    config: ApolloCodegenConfiguration = .mock()
  ) {
    subject = CustomScalarTemplate(
      graphqlScalar: type,
      config: ApolloCodegen.ConfigurationContext(config: config)
    )
  }

  private func renderSubject() -> String {
    subject.renderBodyTemplate(nonFatalErrorRecorder: .init()).description
  }

  // MARK: Casing Tests

  func test__render__givenCustomScalar_shouldGenerateTypealiasNameFirstUppercased() throws {
    // given
    buildSubject(name: "aCustomScalar")

    let expected = """
    typealias ACustomScalar = String

    """

    // when
    let rendered = renderSubject()

    // then
    expect(rendered).to(equalLineByLine(expected))
  }
  
  // MARK: Header Tests
  
  func test__contain_can_edited_header_description() throws {
    // given
    buildSubject()
    
    // when
    let rendered = subject.renderHeaderTemplate(nonFatalErrorRecorder: .init())

    // then
    expect(rendered?.description).toNot(contain("should not be edited"))
    expect(rendered?.description).to(contain("can be edited"))
  }
  
  // MARK: Typealias Definition Tests

  func test__render__givenCustomScalar_shouldGenerateStringTypealias() throws {
    // given
    buildSubject()

    let expected = """
    typealias MyCustomScalar = String

    """

    // when
    let rendered = renderSubject()

    // then
    expect(rendered).to(equalLineByLine(expected))
  }

  // MARK: Access Level Tests

  func test_render_givenModuleType_swiftPackageManager_generatesTypealias_withPublicAccess() {
    // given
    buildSubject(config: .mock(.swiftPackage()))

    let expected = """
    public typealias MyCustomScalar = String
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test_render_givenModuleType_other_generatesTypealias_withPublicAccess() {
    // given
    buildSubject(config: .mock(.other))

    let expected = """
    public typealias MyCustomScalar = String
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test_render_givenModuleType_embeddedInTarget_withInternalAccessModifier_generatesTypealias_withInternalAccess() {
    // given
    buildSubject(config: .mock(.embeddedInTarget(name: "TestTarget", accessModifier: .internal)))

    let expected = """
    typealias MyCustomScalar = String
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  func test_render_givenModuleType_embeddedInTarget_withPublicAccessModifier_generatesTypealias_withPublicAccess() {
    // given
    buildSubject(config: .mock(.embeddedInTarget(name: "TestTarget", accessModifier: .public)))

    let expected = """
    typealias MyCustomScalar = String
    """

    // when
    let actual = renderSubject()

    // then
    expect(actual).to(equalLineByLine(expected, ignoringExtraLines: true))
  }

  // MARK: Documentation Tests

  func test__render__givenSchemaDocumentation_include_hasDocumentation_shouldGenerateDocumentationComment() throws {
    // given
    let documentation = "This is some great documentation!"
    buildSubject(
      type: .mock(
        name: "CustomScalar",
        specifiedByURL: nil,
        documentation: documentation
      ),
      config: .mock(options: .init(schemaDocumentation: .include))
    )

    let expected = """
    /// \(documentation)
    typealias CustomScalar = String

    """

    // when
    let rendered = renderSubject()

    // then
    expect(rendered).to(equalLineByLine(expected))
  }

  func test__render__givenSchemaDocumentation_include_hasDocumentationAndSpecifiedByURL_shouldGenerateDocumentationCommentWithSpecifiedBy() throws {
    // given
    let documentation = "This is some great documentation!"
    buildSubject(
      type: .mock(
        name: "CustomScalar",
        specifiedByURL: "http://www.apollographql.com/scalarSpec",
        documentation: documentation
      ),
      config: .mock(options: .init(schemaDocumentation: .include))
    )

    let expected = """
    /// \(documentation)
    ///
    /// Specified by: [](http://www.apollographql.com/scalarSpec)
    typealias CustomScalar = String

    """

    // when
    let rendered = renderSubject()

    // then
    expect(rendered).to(equalLineByLine(expected))
  }

  func test__render__givenSchemaDocumentation_exclude_hasDocumentation_shouldNotGenerateDocumentationComment() throws {
    // given
    let documentation = "This is some great documentation!"
    buildSubject(
      type: .mock(
        name: "CustomScalar",
        specifiedByURL: nil,
        documentation: documentation
      ),
      config: .mock(options: .init(schemaDocumentation: .exclude))
    )

    let expected = """
    typealias CustomScalar = String
    
    """

    // when
    let rendered = renderSubject()

    // then
    expect(rendered).to(equalLineByLine(expected))
  }
  
  // MARK: - Reserved Keyword Tests
  
  func test__render__givenCustomScalar_usingReservedKeyword_shouldRenderAsEscaped() throws {
    let keywords = ["Type", "type"]

    keywords.forEach { keyword in
      // given
      buildSubject(name: keyword)

      let expected = """
      typealias \(keyword.firstUppercased)_Scalar = String

      """

      // when
      let rendered = renderSubject()

      // then
      expect(rendered).to(equalLineByLine(expected))
    }
  }
  
  // MARK: - Schema Customization Tests
  
  func test__render__givenCustomScalar_withCustomName_shouldRenderWithCustomName() throws {
    // given
    buildSubject(
      name: "MyScalar",
      customName: "MyCustomScalar"
    )

    let expected = """
    // Renamed from GraphQL schema value: 'MyScalar'
    typealias MyCustomScalar = String

    """

    // when
    let rendered = renderSubject()

    // then
    expect(rendered).to(equalLineByLine(expected))
  }
  
}
