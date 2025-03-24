use cardano/assets.{PolicyId}
use cardano/transaction.{Datum, OutputReference, Transaction, Redeemer}
use cardano/address.{Credential, Script }
use aiken/collection/list

validator always {
    mint(_r: Redeemer, _p: PolicyId, _tx: Transaction) -> Bool {
        True
    }

    spend(d: Option<Datum>, _r: Redeemer, _oref: OutputReference, _tx: Transaction) -> Bool {
        when d is {
            Some(_datum)-> True
            None -> False
        }
    }

    else(_) {
        fail
    }
}

validator alwaysW {
    withdraw(_r: Redeemer, _c: Credential, _trx: Transaction) -> Bool{
        True
    }
}

validator vestingTokens {
    mint(_r: Redeemer, p: PolicyId, trx: Transaction) -> Bool {
        let Transaction {outputs, ..} = trx
        expect Some(_ownOut) = list.find(
            outputs, 
            fn(output){
                output.address.payment_credential == Script(p)
            }
        )

        True
    }

    spend(_d: Option<Datum>, _r: Redeemer, _oref: OutputReference, _trx: Transaction) -> Bool {
        True
    }
}