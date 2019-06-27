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
            let cancellableToken = base?.fetch(query: query, cachePolicy: cachePolicy, queue: queue, resultHandler: { (result, error) in
                if let error = error {
                    single(.error(error))
                } else if let errors = result?.errors {
                    single(.error(RxApolloError.graphQLErrors(errors)))
                } else if let data = result?.data {
                    single(.success(data))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    func watch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
                                    queue: DispatchQueue = DispatchQueue.main) -> Single<Query.Data> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.watch(query: query, cachePolicy: cachePolicy, queue: queue, resultHandler: { (result, error) in
                if let error = error {
                    single(.error(error))
                } else if let errors = result?.errors {
                    single(.error(RxApolloError.graphQLErrors(errors)))
                } else if let data = result?.data {
                    single(.success(data))
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
            let cancellableToken = base?.perform(mutation: mutation, queue: queue, resultHandler: { (result, error) in
                if let error = error {
                    single(.error(error))
                } else if let errors = result?.errors {
                    single(.error(RxApolloError.graphQLErrors(errors)))
                } else if let data = result?.data {
                    single(.success(data))
                }
            })
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
