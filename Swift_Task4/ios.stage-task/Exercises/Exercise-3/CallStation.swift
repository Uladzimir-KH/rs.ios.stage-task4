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
                for i in callsList {
                    if (i.outgoingUser == fromUser) {
                        let newCall = Call(id: i.id, incomingUser: i.incomingUser, outgoingUser: i.outgoingUser, status: CallStatus.talk)
                            callsList.append(newCall)
                        
                    }
                }
              
            }
            
        case .end(from: let fromUser):
            
            if (callsList.count > 0) {
                if (callsList.last?.status == .talk) {
                    let newCall = Call(id: callsList.last!.id, incomingUser: callsList.last!.incomingUser, outgoingUser: callsList.last!.outgoingUser, status: CallStatus.ended(reason: .end))
                    if (callsList.last!.outgoingUser == fromUser){
                        callsList.removeLast()
                        callsList.append(newCall)
                    }
                } else if (callsList.last?.status == .calling) {
                    let newCall = Call(id: callsList.last!.id, incomingUser: callsList.last!.incomingUser, outgoingUser: callsList.last!.outgoingUser, status: CallStatus.ended(reason: .cancel))
                  
                        callsList.removeLast()
                        callsList.append(newCall)
            
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
        nil
    }
    
    func currentCall(user: User) -> Call? {
        currentCall
    }
}
