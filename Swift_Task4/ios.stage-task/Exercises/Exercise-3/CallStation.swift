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

    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        
        case .start(from: let fromUser, to: let toUser):
            let newCall = Call(id: UUID(), incomingUser: fromUser, outgoingUser: toUser, status: CallStatus.calling)
            callsList.append(newCall)
            currentCall = newCall
            
        case .answer(from: let fromUser):
            if (callsList.count > 0) {
                for i in 0..<callsList.count {
                    if (callsList[i].outgoingUser == fromUser) {
                        let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.talk)
                            callsList.remove(at: i)
                            callsList.append(newCall)
                    }
                }
              
            }
            
        case .end(from: let fromUser):
            
            if (callsList.count > 0) {
                
                for i in 0..<callsList.count {
                    if (callsList[i].status == .talk && (callsList[i].outgoingUser == fromUser || callsList[i].incomingUser == fromUser)) {
                        let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .end))
                        //if (callsList[i].outgoingUser == fromUser){
                            callsList.remove(at: i)
                            callsList.append(newCall)
                       // }
                    } else if (callsList[i].status == .calling && (callsList[i].outgoingUser == fromUser || callsList[i].incomingUser == fromUser)) {
                        let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .cancel))
                      
                            callsList.remove(at: i)
                            callsList.append(newCall)
                
                    } else if (callsList[i].status == .calling && callsList[i].outgoingUser == fromUser) {
                        for caller in 0..<callsList.count {
                            if ((callsList[i].incomingUser == callsList[caller].incomingUser || callsList[i].incomingUser == callsList[caller].outgoingUser) && callsList[caller].status == .talk){
                                
                            }
                        }
                        let newCall = Call(id: callsList[i].id, incomingUser: callsList[i].incomingUser, outgoingUser: callsList[i].outgoingUser, status: CallStatus.ended(reason: .cancel))
                      
                            callsList.remove(at: i)
                            callsList.append(newCall)
                
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
            if (fromUserCall.incomingUser == user) {
                calls.append(fromUserCall)
                break
            }
        }
        for fromUserCall in callsList {
            if (fromUserCall.outgoingUser == user) {
                calls.append(fromUserCall)
                break
            }
        }
        return callsList
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
