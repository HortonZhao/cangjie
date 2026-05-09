package ohos_app_cangjie_entry.model

import std.collection.*

public class BillEntryDraft {
    var _participants: ArrayList<Person> = ArrayList<Person>()
    var _bills: ArrayList<Bill> = ArrayList<Bill>()
    var _amountTexts: ArrayList<String> = ArrayList<String>()

    public init(
        participants: ArrayList<Person>,
        bills: ArrayList<Bill>,
        amountTexts: ArrayList<String>
    ) {
        this._participants = participants
        this._bills = bills
        this._amountTexts = amountTexts
    }

    public init() {}

    public mut prop participants: ArrayList<Person> {
        get() {
            return this._participants
        }
        set(value) {
            this._participants = value
        }
    }

    public mut prop bills: ArrayList<Bill> {
        get() {
            return this._bills
        }
        set(value) {
            this._bills = value
        }
    }

    public mut prop amountTexts: ArrayList<String> {
        get() {
            return this._amountTexts
        }
        set(value) {
            this._amountTexts = value
        }
    }
}
