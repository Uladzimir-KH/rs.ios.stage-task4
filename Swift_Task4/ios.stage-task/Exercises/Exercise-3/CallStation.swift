import Foundation

final class CallStation {
    var usersList: [User] = []
    var callsList: [Call] = []
    var currentCall: Call?
}

extension CallStation: Station {
    func users() -> [User] {
        usersList
    }
    
    func add(user: User) {
        var ifExist: Bool = false
        for i in usersList {
            if (i == user) {
                ifExist = true
                break
            }
        }
        if (!ifExist) {
            usersList.append(user)
        }
    }
    
    func remove(user: User) {
        for i in 0..<usersList.count {
            if (usersList[i].id == user.id) {
                usersList.remove(at: i)
                break
            }
        }
        if (currentCall?.outgoingUser.id == user.id) {
            currentCall = nil
        }
        
        for i in 0..<callsList.count {
            if (callsList[i].outgoingUser == user && callsList[i].status == .calling) {
                let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .error))
                    callsList.remove(at: i)
                    callsList.append(newCall)
                    break
            }
        }

    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        
        case .start(from: let fromUser, to: let toUser):
           // var userExist = false
            var fromUserExist = false
            var toUserExist = false
            for i in usersList {
                if i.id == fromUser.id {
                    fromUserExist = true
                    break
                }
            }
            for i in usersList.reversed() {
                if i.id == toUser.id {
                    toUserExist = true
                    break
                }
            }
            
            
       if (fromUserExist && toUserExist) {
            var toUserFree = true
            for i in 0..<callsList.count {
                if ((callsList[i].incomingUser == toUser || callsList[i].outgoingUser == toUser) && callsList[i].status == .talk) {
                    toUserFree = false
                    let newCall = Call(id: UUID(), incomingUser: fromUser, outgoingUser: toUser, status: CallStatus.ended(reason: .userBusy))
                        callsList.append(newCall)
                    currentCall = newCall
                    break
                }
            }
            if (toUserFree) {
                let newCall = Call(id: UUID(), incomingUser: fromUser, outgoingUser: toUser, status: CallStatus.calling)
                callsList.append(newCall)
                currentCall = newCall
            }
        
       }
       else if (fromUserExist && !toUserExist) {
                let newCall = Call(id: UUID(), incomingUser: User(id: UUID()), outgoingUser: fromUser, status: CallStatus.ended(reason: .error))
                callsList.append(newCall)
                //currentCall = newCall
       }
            

            
        case .answer(from: let fromUser):
            var userExist = false
            for x in usersList {
                if (x.id == fromUser.id) {
                    userExist = true
                }
            }
            if (userExist) {
                if (callsList.count > 0) {
                    for i in 0..<callsList.count {
                        if (callsList[i].outgoingUser == fromUser) {
                            let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.talk)
                                callsList.remove(at: i)
                                callsList.append(newCall)
                                break
                        }
                    }
                }
            } else {
                return nil
            }
//            else {
//                if (callsList.count > 0) {
//                    for i in 0..<callsList.count {
//                        if (callsList[i].outgoingUser == fromUser) {
//                            let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .error))
//                                callsList.remove(at: i)
//                                callsList.append(newCall)
//
//                        }
//                    }
//
//                }
//            }
            
            
        case .end(from: let fromUser):
            
            if (callsList.count > 0) {
                
                for i in 0..<callsList.count {
                    
                    if (callsList[i].outgoingUser == fromUser) {
                        
                        if (callsList[i].status == .calling) {
                            let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .cancel))
                          
                                callsList.remove(at: i)
                                callsList.append(newCall)
                        } else
                        
                        if (callsList[i].status == .talk) {
                            let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .end))
                          
                                callsList.remove(at: i)
                                callsList.append(newCall)
                        }

                        
                        
                    } else if (callsList[i].incomingUser == fromUser) {
                        if (callsList[i].status == .talk) {
                            let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .end))
                          
                                callsList.remove(at: i)
                                callsList.append(newCall)
                        }

                    }
                    

                }
                
            }
            currentCall = nil
        }
        return callsList.last?.id ?? nil
    }
    
    func calls() -> [Call] {
        callsList
    }
    
    func calls(user: User) -> [Call] {
        var calls: [Call] = []
        for fromUserCall in callsList {
            if (fromUserCall.incomingUser.id == user.id || fromUserCall.outgoingUser.id == user.id) {
                var ifCounted = false
                for i in calls {
                    if (i.id == fromUserCall.id) {
                        ifCounted = true
                        break
                    }
                }
                if (!ifCounted) {
                    calls.append(fromUserCall)
                }
            }
        }
       
        return calls
    }
    
    func call(id: CallID) -> Call? {
        var call: Call?
        for i in callsList {
            if (i.id == id){
                call = i
                break
            }
        }
        return call
    }
    
    func currentCall(user: User) -> Call? {
        currentCall
    }
}
