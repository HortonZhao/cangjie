/**
 * Created on 2026/5/2
 */
package ohos_app_cangjie_entry.logic

import ohos_app_cangjie_entry.model.*

import std.collection.*
import std.sort.*
import std.math.min

public class SettlementSolver {
    func ensureParticipant(balances: HashMap<Person, Float64>, person: Person): Unit {
        match (balances.get(person)) {
            case Some(_) => ()
            case None => balances[person] = 0.0
        }
    }

    func ensureName(totals: HashMap<String, Float64>, name: String): Unit {
        match (totals.get(name)) {
            case Some(_) => ()
            case None => totals[name] = 0.0
        }
    }

    func appendNameIfMissing(names: ArrayList<String>, name: String) {
        if (name.isEmpty() || name.isAsciiBlank()) {
            return
        }
        for (existing in names) {
            if (existing == name) {
                return
            }
        }
        names.append(name)
    }

    func collectParticipantNames(input: BillInput): ArrayList<String> {
        let names = ArrayList<String>()
        for (person in input.participants) {
            this.appendNameIfMissing(names, person.name)
        }
        for (bill in input.bills) {
            this.appendNameIfMissing(names, bill.payer.name)
            for (consumer in bill.consumers) {
                this.appendNameIfMissing(names, consumer.name)
            }
        }
        return names
    }

    func computeBillShares(bill: Bill): ArrayList<(Person, Float64)> {
        let shares = ArrayList<(Person, Float64)>()
        let consumers = bill.consumers
        if (consumers.size == 0) {
            return shares
        }

        let weights = bill.weights
        var useWeights = false
        var totalWeight = 0.0
        if (weights.size == consumers.size) {
            var idx = 0
            while (idx < weights.size) {
                let rawWeight = weights.get(idx).getOrThrow()
                if (rawWeight > 0.0) {
                    totalWeight = totalWeight + rawWeight
                }
                idx++
            }
            if (totalWeight > 0.0) {
                useWeights = true
            }
        }

        if (useWeights) {
            var idx = 0
            while (idx < consumers.size) {
                let consumer = consumers.get(idx).getOrThrow()
                let rawWeight = weights.get(idx).getOrThrow()
                var weight = rawWeight
                if (weight < 0.0) {
                    weight = 0.0
                }
                let share = bill.amount * weight / totalWeight
                shares.append((consumer, share))
                idx++
            }
        } else {
            let shareAmount = bill.amount / Float64(consumers.size)
            for (consumer in consumers) {
                shares.append((consumer, shareAmount))
            }
        }

        return shares
    }

    public func computeNetBalances(input: BillInput): HashMap<Person, Float64> {
        let balances = HashMap<Person, Float64>()

        for (person in input.participants) {
            balances.put(person, 0.0)
        }

        for (bill in input.bills) {
            let payer = bill.payer
            let amount = bill.amount
            let consumers = bill.consumers

            this.ensureParticipant(balances, payer)
            for (consumer in consumers) {
                this.ensureParticipant(balances, consumer)
            }

            balances[payer] = balances[payer] + amount

            let shares = this.computeBillShares(bill)
            if (shares.size == 0) {
                continue
            }
            for (share in shares) {
                let consumer = share[0]
                let shareAmount = share[1]
                balances[consumer] = balances[consumer] - shareAmount
            }
        }

        return balances
    }

    public func minimizeTransfers(balances: HashMap<Person, Float64>): ArrayList<Transfer> {
        let debtors = ArrayList<(Person, Float64)>()
        let creditors = ArrayList<(Person, Float64)>()

        for ((person, balance) in balances) {
            if (balance < -0.01) {
                debtors.append((person, -balance))
            } else if (balance > 0.01) {
                creditors.append((person, balance))
            }
        }

        debtors.sortBy(stable: false, comparator: {a: (Person, Float64), b: (Person, Float64) =>
            if (a[1] > b[1]) {
                return Ordering.LT
            } else if (a[1] == b[1]) {
                return Ordering.EQ
            } else {
                return Ordering.GT
            }
        })
        creditors.sortBy(stable: false, comparator: {a: (Person, Float64), b: (Person, Float64) =>
            if (a[1] > b[1]) {
                return Ordering.LT
            } else if (a[1] == b[1]) {
                return Ordering.EQ
            } else {
                return Ordering.GT
            }
        })

        let transfers = ArrayList<Transfer>()
        var i = 0
        var j = 0

        while (i < debtors.size && j < creditors.size) {
            let debtor = debtors[i]
            let creditor = creditors[j]
            let amount = min(debtor[1], creditor[1])

            if (amount > 0.01) {
                transfers.append(Transfer(debtor[0], creditor[0], amount))
            }

            debtors[i] = (debtor[0], debtor[1] - amount)
            creditors[j] = (creditor[0], creditor[1] - amount)

            if (debtors[i][1] < 0.01) {
                i++
            }
            if (creditors[j][1] < 0.01) {
                j++
            }
        }

        return transfers
    }

    public func settle(input: BillInput): SettlementResult {
        let balances = this.computeNetBalances(input)

        let balanceDisplay = HashMap<String, Float64>()
        for ((person, balance) in balances) {
            balanceDisplay.put(person.name, balance)
        }

        let transfers = this.minimizeTransfers(balances)
        let paidTotals = HashMap<String, Float64>()
        let consumedTotals = HashMap<String, Float64>()
        let participantNames = this.collectParticipantNames(input)

        for (name in participantNames) {
            this.ensureName(paidTotals, name)
            this.ensureName(consumedTotals, name)
        }

        for (bill in input.bills) {
            let payerName = bill.payer.name
            this.ensureName(paidTotals, payerName)
            paidTotals[payerName] = paidTotals[payerName] + bill.amount

            let shares = this.computeBillShares(bill)
            for (share in shares) {
                let consumer = share[0]
                let shareAmount = share[1]
                let consumerName = consumer.name
                this.ensureName(consumedTotals, consumerName)
                consumedTotals[consumerName] = consumedTotals[consumerName] + shareAmount
            }
        }

        return SettlementResult(
            transfers,
            balanceDisplay,
            paidTotals,
            consumedTotals,
            participantNames
        )
    }
}
