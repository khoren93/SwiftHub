//
//  Apollo+Rx.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 3/9/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo

enum RxApolloError: Error {
    case graphQLErrors([GraphQLError])
}

extension ApolloClient: ReactiveCompatible {}

extension Reactive where Base: ApolloClient {

    func fetch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    queue: DispatchQueue = DispatchQueue.main) -> Single<Query.Data> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: nil, queue: queue, resultHandler: { (result) in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        single(.success(data))
                    } else if let errors = graphQLResult.errors {
                        // GraphQL errors
                        single(.failure(RxApolloError.graphQLErrors(errors)))
                    }
                case .failure(let error):
                    // Network or response format errors
                    single(.failure(error))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    func watch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch) -> Single<Query.Data> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.watch(query: query, cachePolicy: cachePolicy, resultHandler: { (result) in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        single(.success(data))
                    } else if let errors = graphQLResult.errors {
                        // GraphQL errors
                        single(.failure(RxApolloError.graphQLErrors(errors)))
                    }
                case .failure(let error):
                    // Network or response format errors
                    single(.failure(error))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                            queue: DispatchQueue = DispatchQueue.main) -> Single<Mutation.Data> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.perform(mutation: mutation, queue: queue, resultHandler: { (result) in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        single(.success(data))
                    } else if let errors = graphQLResult.errors {
                        // GraphQL errors
                        single(.failure(RxApolloError.graphQLErrors(errors)))
                    }
                case .failure(let error):
                    // Network or response format errors
                    single(.failure(error))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
