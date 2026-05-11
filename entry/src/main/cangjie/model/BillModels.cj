/**
 * Created on 2026/5/2
 */
package ohos_app_cangjie_entry.model

import std.collection.HashMap
import std.collection.ArrayList

import ohos_app_cangjie_entry.utils.*
import serialization.serialization.*

public class Person <: Hashable & Equatable<Person> & Serializable<Person> {
    var _name: String = ""

    public init(name: String) {
        this._name = name
    }

    public init() {}

    public func hashCode(): Int64 {
        return _name.hashCode()
    }

    public operator func ==(other: Person): Bool {
        return this._name == other._name
    }

    public operator func !=(other: Person): Bool {
        return this._name != other._name
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("name", this._name))
    }

    public static func deserialize(dm: DataModel): Person {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = Person()
        result.name = String.deserialize(dms.get("name"))
        return result
    }

    @property[String](name)
}

public class Bill <: Serializable<Bill> {
    var _payer: Person = Person()
    var _amount: Float64 = 0.0
    var _note: String = ""
    var _consumers: ArrayList<Person> = ArrayList<Person>()
    var _weights: ArrayList<Float64> = ArrayList<Float64>()

    public init(payer: Person, amount: Float64, consumers: ArrayList<Person>) {
        this._payer = payer
        this._amount = amount
        this._consumers = consumers
    }

    public init(payer: Person, amount: Float64, consumers: ArrayList<Person>, note: String) {
        this._payer = payer
        this._amount = amount
        this._consumers = consumers
        this._note = note
    }

    public init(payer: Person, amount: Float64, consumers: ArrayList<Person>, weights: ArrayList<Float64>) {
        this._payer = payer
        this._amount = amount
        this._consumers = consumers
        this._weights = weights
    }

    public init(payer: Person, amount: Float64, consumers: ArrayList<Person>, weights: ArrayList<Float64>, note: String) {
        this._payer = payer
        this._amount = amount
        this._consumers = consumers
        this._weights = weights
        this._note = note
    }

    public init() {}

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Person>("payer", this._payer))
            .add(field<Float64>("amount", this._amount))
            .add(field<String>("note", this._note))
            .add(field<ArrayList<Person>>("consumers", this._consumers))
            .add(field<ArrayList<Float64>>("weights", this._weights))
    }

    public static func deserialize(dm: DataModel): Bill {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = Bill()
        result.payer = Person.deserialize(dms.get("payer"))
        result.amount = Float64.deserialize(dms.get("amount"))
        var note = ""
        try {
            note = String.deserialize(dms.get("note"))
        } catch (e: Exception) {
            note = ""
        }
        result.note = note
        result.consumers = ArrayList<Person>.deserialize(dms.get("consumers"))
        var weights = ArrayList<Float64>()
        try {
            weights = ArrayList<Float64>.deserialize(dms.get("weights"))
        } catch (e: Exception) {
            weights = ArrayList<Float64>()
        }
        result.weights = weights
        return result
    }

    @property[Person](payer)
    @property[Float64](amount)
    @property[String](note)
    @property[ArrayList<Person>](consumers)
    @property[ArrayList<Float64>](weights)
}

public class BillInput <: Serializable<BillInput> {
    var _participants: ArrayList<Person> = ArrayList<Person>()
    var _bills: ArrayList<Bill> = ArrayList<Bill>()

    public init(participants: ArrayList<Person>, bills: ArrayList<Bill>) {
        this._participants = participants
        this._bills = bills
    }

    public init() {}

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<ArrayList<Person>>("participants", this._participants))
            .add(field<ArrayList<Bill>>("bills", this._bills))
    }

    public static func deserialize(dm: DataModel): BillInput {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = BillInput()
        result.participants = ArrayList<Person>.deserialize(dms.get("participants"))
        result.bills = ArrayList<Bill>.deserialize(dms.get("bills"))
        return result
    }

    @property[ArrayList<Person>](participants)
    @property[ArrayList<Bill>](bills)
}

public class Transfer <: Serializable<Transfer> {
    var _from: Person = Person()
    var _to: Person = Person()
    var _amount: Float64 = 0.0

    public init(from: Person, to: Person, amount: Float64) {
        this._from = from
        this._to = to
        this._amount = amount
    }

    public init() {}

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<Person>("from", this._from))
            .add(field<Person>("to", this._to))
            .add(field<Float64>("amount", this._amount))
    }

    public static func deserialize(dm: DataModel): Transfer {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = Transfer()
        result.from = Person.deserialize(dms.get("from"))
        result.to = Person.deserialize(dms.get("to"))
        result.amount = Float64.deserialize(dms.get("amount"))
        return result
    }

    @property[Person](from)
    @property[Person](to)
    @property[Float64](amount)
}

public class SettlementResult <: Serializable<SettlementResult> {
    var _transfers: ArrayList<Transfer> = ArrayList<Transfer>()
    var _balances: HashMap<String, Float64> = HashMap<String, Float64>()
    var _paidTotals: HashMap<String, Float64> = HashMap<String, Float64>()
    var _consumedTotals: HashMap<String, Float64> = HashMap<String, Float64>()
    var _participantNames: ArrayList<String> = ArrayList<String>()

    public init(transfers: ArrayList<Transfer>, balances: HashMap<String, Float64>) {
        this._transfers = transfers
        this._balances = balances
        this._paidTotals = HashMap<String, Float64>()
        this._consumedTotals = HashMap<String, Float64>()
        this._participantNames = ArrayList<String>()
    }

    public init(transfers: ArrayList<Transfer>, balances: HashMap<String, Float64>, paidTotals: HashMap<String, Float64>, consumedTotals: HashMap<String, Float64>) {
        this._transfers = transfers
        this._balances = balances
        this._paidTotals = paidTotals
        this._consumedTotals = consumedTotals
        this._participantNames = ArrayList<String>()
    }

    public init(transfers: ArrayList<Transfer>, balances: HashMap<String, Float64>, paidTotals: HashMap<String, Float64>, consumedTotals: HashMap<String, Float64>, participantNames: ArrayList<String>) {
        this._transfers = transfers
        this._balances = balances
        this._paidTotals = paidTotals
        this._consumedTotals = consumedTotals
        this._participantNames = participantNames
    }

    public init() {}

    public func serialize(): DataModel {
        return DataModelStruct()
            .add(field<ArrayList<Transfer>>("transfers", this._transfers))
            .add(field<HashMap<String, Float64>>("balances", this._balances))
            .add(field<HashMap<String, Float64>>("paidTotals", this._paidTotals))
            .add(field<HashMap<String, Float64>>("consumedTotals", this._consumedTotals))
            .add(field<ArrayList<String>>("participantNames", this._participantNames))
    }

    public static func deserialize(dm: DataModel): SettlementResult {
        let dms = match (dm) {
            case data: DataModelStruct => data
            case _ => throw Exception("this data is not DataModelStruct")
        }
        let result = SettlementResult()
        result.transfers = ArrayList<Transfer>.deserialize(dms.get("transfers"))
        result.balances = HashMap<String, Float64>.deserialize(dms.get("balances"))

        var paidTotals = HashMap<String, Float64>()
        try {
            paidTotals = HashMap<String, Float64>.deserialize(dms.get("paidTotals"))
        } catch (e: Exception) {
            paidTotals = HashMap<String, Float64>()
        }

        var consumedTotals = HashMap<String, Float64>()
        try {
            consumedTotals = HashMap<String, Float64>.deserialize(dms.get("consumedTotals"))
        } catch (e: Exception) {
            consumedTotals = HashMap<String, Float64>()
        }

        var participantNames = ArrayList<String>()
        try {
            participantNames = ArrayList<String>.deserialize(dms.get("participantNames"))
        } catch (e: Exception) {
            participantNames = ArrayList<String>()
        }

        result.paidTotals = paidTotals
        result.consumedTotals = consumedTotals
        result.participantNames = participantNames
        return result
    }

    @property[ArrayList<Transfer>](transfers)
    @property[HashMap<String, Float64>](balances)
    @property[HashMap<String, Float64>](paidTotals)
    @property[HashMap<String, Float64>](consumedTotals)
    @property[ArrayList<String>](participantNames)
}
