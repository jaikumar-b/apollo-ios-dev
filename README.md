# Apollo iOS [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg?maxAge=2592000)](https://raw.githubusercontent.com/apollostack/apollo-ios/master/LICENSE.md) [![GitHub release](https://img.shields.io/github/release/apollostack/apollo-ios.svg?maxAge=2592000)](https://github.com/apollostack/apollo-ios/releases) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)  [![CocoaPods](https://img.shields.io/cocoapods/v/Apollo.svg?maxAge=2592000)](https://cocoapods.org/pods/Apollo)

Apollo iOS is a GraphQL client for iOS, written in Swift.

Although JSON responses are convenient to work with in dynamic languages like JavaScript, dealing with dictionaries and untyped values is a pain in statically typed languages such as Swift.

The main design goal of the current version of Apollo iOS is therefore to return typed results for GraphQL queries. Instead of passing around dictionaries and making clients cast field values to the right type manually, the types returned allow you to access data and navigate relationships using the appropriate native types directly.

These result types are generated from a GraphQL schema and a set of query documents by [`apollo-codegen`](https://github.com/apollostack/apollo-codegen). It currently only generates code for a subset of GraphQL queries. Most importantly, fragments with polymorphic type conditions and mutations are not yet supported.

For more details on the proposed mapping from GraphQL results to Swift types, see the [design docs](DESIGN.md).

## Getting Started

[Apollo iOS Quickstart](https://github.com/apollostack/apollo-ios-quickstart) is a collection of sample Xcode projects that makes it easy to get started with Apollo iOS.

## Development

This project is being developed using Xcode 8 and Swift 3.

If you open `Apollo.xcodeproj`, you should be able to run the tests of the Apollo target.

Some of the tests run against [an example GraphQL server](https://github.com/jahewson/graphql-starwars) (see installation instructions there) using the Star Wars data bundled with Facebook's reference implementation, [GraphQL.js](https://github.com/graphql/graphql-js).
