//
//  Observable+.swift
//  TaskSample
//
//  Created by 이시원 on 11/9/23.
//

import RxSwift

extension Observable {
    static func task<T>(type: T.Type, _ c: @escaping () async throws -> T) -> Observable<T> {
        return Single<T>.create { single in
            let task = Task {
                do {
                    let v = try await c()
                    single(.success(v))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create() {
              task.cancel()
            }
        }
        .asObservable()
    }
}
