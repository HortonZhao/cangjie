package ohos_app_cangjie_entry.state

import std.collection.*

import ohos_app_cangjie_entry.model.*

public class AppSession {
    private static var billEntryResetSeed: Int64 = 0
    private static var billEntryDraft: BillEntryDraft =
        BillEntryDraft()

    public static func loadBillEntryDraft(): BillEntryDraft {
        AppSession.ensureBillEntryDraft()
        return BillEntryDraft(
            AppSession.cloneParticipants(
                AppSession.billEntryDraft.participants
            ),
            AppSession.cloneBills(
                AppSession.billEntryDraft.bills
            ),
            AppSession.cloneAmountTexts(
                AppSession.billEntryDraft.amountTexts
            )
        )
    }

    public static func saveBillEntryDraft(
        participants: ArrayList<Person>,
        bills: ArrayList<Bill>,
        amountTexts: ArrayList<String>
    ) {
        AppSession.billEntryDraft = BillEntryDraft(
            AppSession.cloneParticipants(participants),
            AppSession.cloneBills(bills),
            AppSession.cloneAmountTexts(amountTexts)
        )
    }

    public static func restartBillEntry(): String {
        billEntryResetSeed = billEntryResetSeed + 1
        AppSession.billEntryDraft =
            AppSession.buildDefaultBillEntryDraft()
        return "__RESET_BILL_ENTRY__:${billEntryResetSeed}"
    }

    private static func ensureBillEntryDraft() {
        if (
            AppSession.billEntryDraft.participants.size ==
                0 &&
            AppSession.billEntryDraft.bills.size == 0 &&
            AppSession.billEntryDraft.amountTexts.size ==
                0
        ) {
            AppSession.billEntryDraft =
                AppSession.buildDefaultBillEntryDraft()
        }
    }

    private static func buildDefaultBillEntryDraft(): BillEntryDraft {
        let participants = ArrayList<Person>()
        let bills = ArrayList<Bill>()
        let amountTexts = ArrayList<String>()

        return BillEntryDraft(
            participants,
            bills,
            amountTexts
        )
    }

    private static func cloneParticipants(
        participants: ArrayList<Person>
    ): ArrayList<Person> {
        let copies = ArrayList<Person>()
        for (participant in participants) {
            copies.append(Person(participant.name))
        }
        return copies
    }

    private static func cloneBills(
        bills: ArrayList<Bill>
    ): ArrayList<Bill> {
        let copies = ArrayList<Bill>()
        for (bill in bills) {
            let consumers = ArrayList<Person>()
            let weights = ArrayList<Float64>()
            for (consumer in bill.consumers) {
                consumers.append(Person(consumer.name))
            }
            for (weight in bill.weights) {
                weights.append(weight)
            }
            copies.append(
                Bill(
                    Person(bill.payer.name),
                    bill.amount,
                    consumers,
                    weights,
                    bill.note
                )
            )
        }
        return copies
    }

    private static func cloneAmountTexts(
        amountTexts: ArrayList<String>
    ): ArrayList<String> {
        let copies = ArrayList<String>()
        for (amountText in amountTexts) {
            copies.append(amountText)
        }
        return copies
    }
}
