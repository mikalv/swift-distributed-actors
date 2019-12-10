// ==== ------------------------------------------------------------------ ====
// === DO NOT EDIT: Generated by GenActors                     
// ==== ------------------------------------------------------------------ ====

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2018-2019 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

// tag::imports[]

import DistributedActors

// end::imports[]

import DistributedActorsTestKit
import XCTest

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated Greeter messages 

/// DO NOT EDIT: Generated Greeter messages
extension Greeter {
    // TODO: make Message: Codable - https://github.com/apple/swift-distributed-actors/issues/262
    public enum Message { 
        case greet(name: String, _replyTo: ActorRef<String>) 
    }

    
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated Greeter behavior

extension Greeter {

    public static func makeBehavior(instance: Greeter) -> Behavior<Message> {
        return .setup { _context in
            let context = Actor<Greeter>.Context(underlying: _context)
            let instance = instance

            /* await */ instance.preStart(context: context)

            return Behavior<Message>.receiveMessage { message in
                switch message { 
                
                case .greet(let name, let _replyTo):
                    let result = instance.greet(name: name)
                    _replyTo.tell(result)
 
                
                }
                return .same
            }.receiveSignal { _context, signal in 
                let context = Actor<Greeter>.Context(underlying: _context)

                switch signal {
                case is Signals.PostStop: 
                    instance.postStop(context: context)
                    return .same
                case let terminated as Signals.Terminated:
                    switch instance.receiveTerminated(context: context, terminated: terminated) {
                    case .unhandled: 
                        return .unhandled
                    case .stop: 
                        return .stop
                    case .ignore: 
                        return .same
                    }
                default:
                    return .unhandled
                }
            }
        }
    }
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: Extend Actor for Greeter

extension Actor where A.Message == Greeter.Message {

    func greet(name: String) -> Reply<String> {
        // TODO: FIXME perhaps timeout should be taken from context
        Reply(nioFuture:
            self.ref.ask(for: String.self, timeout: .effectivelyInfinite) { _replyTo in
                .greet(name: name, _replyTo: _replyTo)}
            .nioFuture
            )
    }
 

}