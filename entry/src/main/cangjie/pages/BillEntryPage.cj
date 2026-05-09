package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router

import std.collection.*
import std.convert.Parsable
import encoding.json.*

import ohos_app_cangjie_entry.logic.*
import ohos_app_cangjie_entry.model.*
import ohos_app_cangjie_entry.state.AppSession

@Entry
@Component
class BillEntryPage {
    @State
    var participants: ArrayList<Person> =
        ArrayList<Person>()

    @State
    var bills: ArrayList<Bill> =
        ArrayList<Bill>()

    @State
    var amountTexts: ArrayList<String> =
        ArrayList<String>()

    @State
    var showError: Bool = false

    @State
    var errorMsg: String = ""

    public func aboutToAppear() {
        let draft = AppSession.loadBillEntryDraft()
        this.participants = draft.participants
        this.bills = draft.bills
        this.amountTexts = draft.amountTexts
        this.showError = false
        this.errorMsg = ""
        this.syncBillsWithParticipants()
        this.refreshParticipants()
        this.refreshBills()
        this.persistDraft()
    }

    func build() {
        Column {
            Scroll {
                Column {
                    buildHeader()

                    if (this.showError) {
                        Text(this.errorMsg)
                            .fontSize(13)
                            .fontColor(Color(0xFFD33A2C))
                            .margin(
                                left: 16,
                                right: 16,
                                top: 8,
                                bottom: 8
                            )
                            .padding(10)
                            .backgroundColor(
                                Color(0xFFFFECEA)
                            )
                            .borderRadius(6)
                    }

                    buildParticipantCard()
                    buildBillCardList()
                }
                .width(100.percent)
                .padding(bottom: 16)
            }
            .width(100.percent)
            .height(86.percent)

            Button("开始结算")
                .onClick { _ =>
                    this.startSettlement()
                }
                .width(92.percent)
                .height(50)
                .margin(bottom: 14)
                .fontSize(17)
                .fontColor(Color.WHITE)
                .backgroundColor(Color(0xFF2767F7))
                .borderRadius(8)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(Color(0xFFF4F6F8))
    }

    @Builder
    func buildHeader() {
        Column {
            Text("智能AA记账本")
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color(0xFF061B31))

            Text("请录入参与人和账单信息")
                .fontSize(14)
                .fontColor(Color(0xFF64748D))
                .margin(top: 6)
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(top: 24, left: 18, right: 18, bottom: 10)
    }

    @Builder
    func buildParticipantCard() {
        Column {
            Text("参与人")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color(0xFF061B31))
                .margin(bottom: 10)

            ForEach(
                this.participantIndexes(),
                itemGeneratorFunc: {
                    item: Int64,
                    tag: Int64 =>
                        this.buildParticipantRow(item)
                }
            )

            Button("新增参与人")
                .onClick { _ =>
                    this.addParticipant()
                }
                .height(40)
                .width(100.percent)
                .fontSize(14)
                .fontColor(Color(0xFF2767F7))
                .backgroundColor(Color(0xFFEFF4FF))
                .borderRadius(6)
                .margin(top: 6)
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(top: 16, left: 14, right: 14, bottom: 14)
        .margin(left: 14, right: 14, top: 8)
        .backgroundColor(Color.WHITE)
        .borderRadius(8)
        .borderWidth(1)
        .borderColor(Color(0xFFE5EDF5))
    }

    @Builder
    func buildParticipantRow(index: Int64) {
        if (
            index >= 0 &&
            index < this.participants.size
        ) {
            Row {
                TextInput(
                    placeholder: "姓名",
                    text: this.participants[index].name
                )
                    .onChange {
                        value => this.updateParticipantName(
                            index,
                            value
                        )
                    }
                    .height(42)
                    .width(78.percent)
                    .fontSize(14)
                    .borderRadius(6)
                    .borderWidth(1)
                    .borderColor(Color(0xFFE5EDF5))
                    .backgroundColor(Color.WHITE)

                Button("删除")
                    .onClick { _ =>
                        this.removeParticipant(index)
                    }
                    .height(38)
                    .width(20.percent)
                    .fontSize(13)
                    .fontColor(Color.WHITE)
                    .backgroundColor(Color(0xFFD33A2C))
                    .borderRadius(6)
            }
            .width(100.percent)
            .justifyContent(FlexAlign.SpaceBetween)
            .margin(bottom: 8)
        } else {
            Row {}
        }
    }

    @Builder
    func buildBillCardList() {
        Column {
            Text("账单列表")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color(0xFF061B31))
                .margin(bottom: 10)

            ForEach(
                this.billIndexes(),
                itemGeneratorFunc: {
                    item: Int64,
                    tag: Int64 =>
                        this.buildSingleBillCard(item)
                }
            )

            Button("新增账单")
                .onClick { _ =>
                    this.addBill()
                }
                .height(40)
                .width(100.percent)
                .fontSize(14)
                .fontColor(Color(0xFF2767F7))
                .backgroundColor(Color(0xFFEFF4FF))
                .borderRadius(6)
                .margin(top: 8)
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(top: 16, left: 14, right: 14, bottom: 14)
        .margin(left: 14, right: 14, top: 10, bottom: 10)
        .backgroundColor(Color.WHITE)
        .borderRadius(8)
        .borderWidth(1)
        .borderColor(Color(0xFFE5EDF5))
    }

    @Builder
    func buildSingleBillCard(index: Int64) {
        if (
            index >= 0 &&
            index < this.bills.size
        ) {
            Column {
                Row {
                    Text("账单 ${index + 1}")
                        .fontSize(15)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(Color(0xFF061B31))

                    Button("删除账单")
                        .onClick { _ =>
                            this.removeBill(index)
                        }
                        .height(30)
                        .fontSize(12)
                        .fontColor(Color.WHITE)
                        .backgroundColor(Color(0xFF6B7280))
                        .borderRadius(6)
                }
                .width(100.percent)
                .justifyContent(FlexAlign.SpaceBetween)
                .margin(bottom: 10)

                Text("付款人")
                    .fontSize(13)
                    .fontColor(Color(0xFF273951))

                buildPayerSelector(index)

                Text("金额")
                    .fontSize(13)
                    .fontColor(Color(0xFF273951))
                    .margin(top: 10)

                TextArea(
                    placeholder: "请输入金额",
                    text: this.amountTextAt(index)
                )
                    .onChange {
                        value => this.updateAmountText(
                            index,
                            value
                        )
                    }
                    .height(40)
                    .width(100.percent)
                    .fontSize(14)
                    .borderRadius(6)
                    .borderWidth(1)
                    .borderColor(Color(0xFFE5EDF5))
                    .backgroundColor(Color.WHITE)
                    .margin(top: 6)

                Text("消费者")
                    .fontSize(13)
                    .fontColor(Color(0xFF273951))
                    .margin(top: 10)

                buildConsumerSelector(index)
            }
            .width(100.percent)
            .alignItems(HorizontalAlign.Start)
            .padding(12)
            .margin(bottom: 10)
            .backgroundColor(Color(0xFFFCFDFE))
            .borderRadius(8)
            .borderWidth(1)
            .borderColor(Color(0xFFE5EDF5))
        } else {
            Column {}
        }
    }

    @Builder
    func buildPayerSelector(billIndex: Int64) {
        if (this.participants.size == 0) {
            Text("暂无参与人")
                .fontSize(12)
                .fontColor(Color(0xFF9CA3AF))
                .margin(top: 6)
        } else {
            Scroll {
                Row {
                    ForEach(
                        this.participantNames(),
                        itemGeneratorFunc: {
                            item: String,
                            tag: Int64 =>
                                this.buildPayerOption(
                                    billIndex,
                                    tag,
                                    item
                                )
                        }
                    )
                }
            }
            .width(100.percent)
            .height(40)
            .margin(top: 6)
        }
    }

    @Builder
    func buildConsumerSelector(billIndex: Int64) {
        if (this.participants.size == 0) {
            Text("暂无可选消费者")
                .fontSize(12)
                .fontColor(Color(0xFF9CA3AF))
                .margin(top: 6)
        } else {
            Scroll {
                Row {
                    ForEach(
                        this.participantNames(),
                        itemGeneratorFunc: {
                            item: String,
                            tag: Int64 =>
                                this.buildConsumerOption(
                                    billIndex,
                                    tag,
                                    item
                                )
                        }
                    )
                }
            }
            .width(100.percent)
            .height(40)
            .margin(top: 6)
        }
    }

    @Builder
    func buildPayerOption(
        billIndex: Int64,
        i: Int64,
        name: String
    ) {
        if (
            i >= 0 &&
            i < this.participants.size &&
            billIndex >= 0 &&
            billIndex < this.bills.size
        ) {
            if (
                this.isPayerSelected(
                    billIndex,
                    i
                )
            ) {
                Button(
                    this.displayName(name)
                )
                    .onClick { _ =>
                        this.selectPayer(
                            billIndex,
                            i
                        )
                    }
                    .height(32)
                    .fontSize(12)
                    .margin(right: 8)
                    .fontColor(Color.WHITE)
                    .backgroundColor(Color(0xFF2767F7))
                    .borderRadius(6)
            } else {
                Button(
                    this.displayName(name)
                )
                    .onClick { _ =>
                        this.selectPayer(
                            billIndex,
                            i
                        )
                    }
                    .height(32)
                    .fontSize(12)
                    .margin(right: 8)
                    .fontColor(Color(0xFF2767F7))
                    .backgroundColor(Color(0xFFEFF4FF))
                    .borderRadius(6)
            }
        } else {
            Text("")
        }
    }

    @Builder
    func buildConsumerOption(
        billIndex: Int64,
        i: Int64,
        name: String
    ) {
        if (
            i >= 0 &&
            i < this.participants.size &&
            billIndex >= 0 &&
            billIndex < this.bills.size
        ) {
            if (
                this.isConsumerSelected(
                    billIndex,
                    i
                )
            ) {
                Button(
                    this.displayName(name)
                )
                    .onClick { _ =>
                        this.toggleConsumer(
                            billIndex,
                            i
                        )
                    }
                    .height(32)
                    .fontSize(12)
                    .margin(right: 8)
                    .fontColor(Color.WHITE)
                    .backgroundColor(Color(0xFF15BE53))
                    .borderRadius(6)
            } else {
                Button(
                    this.displayName(name)
                )
                    .onClick { _ =>
                        this.toggleConsumer(
                            billIndex,
                            i
                        )
                    }
                    .height(32)
                    .fontSize(12)
                    .margin(right: 8)
                    .fontColor(Color(0xFF108C3D))
                    .backgroundColor(Color(0xFFE9F9EE))
                    .borderRadius(6)
            }
        } else {
            Text("")
        }
    }

    func addParticipant() {
        let next = ArrayList<Person>(this.participants)
        next.append(Person(""))
        this.participants = next
        this.syncBillsWithParticipants()
        this.refreshBills()
        this.persistDraft()
    }

    func removeParticipant(index: Int64) {
        if (index < 0 || index >= this.participants.size) {
            return
        }
        if (this.participants.size <= 1) {
            this.showError = true
            this.errorMsg = "至少保留 1 个参与人"
            return
        }

        let nextParticipants = ArrayList<Person>(
            this.participants
        )
        let removed = nextParticipants[index]
        nextParticipants.remove(index)
        this.participants = nextParticipants

        for (bill in this.bills) {
            if (bill.payer.name == removed.name) {
                bill.payer = Person("")
            }

            var i = 0
            while (i < bill.consumers.size) {
                if (
                    bill.consumers[i].name == removed.name
                ) {
                    bill.consumers.remove(i)
                } else {
                    i = i + 1
                }
            }
        }

        this.syncBillsWithParticipants()
        this.refreshBills()
        this.persistDraft()
    }

    func updateParticipantName(
        index: Int64,
        value: String
    ) {
        if (index < 0 || index >= this.participants.size) {
            return
        }

        let oldName = this.participants[index].name
        let newPerson = Person(value)

        let nextParticipants = ArrayList<Person>(
            this.participants
        )
        nextParticipants[index] = newPerson
        this.participants = nextParticipants

        let nextBills = ArrayList<Bill>()
        for (bill in this.bills) {
            var nextPayer = bill.payer
            if (bill.payer.name == oldName) {
                nextPayer = newPerson
            }

            let nextConsumers = ArrayList<Person>()
            for (consumer in bill.consumers) {
                if (consumer.name == oldName) {
                    nextConsumers.append(newPerson)
                } else {
                    nextConsumers.append(consumer)
                }
            }

            nextBills.append(
                Bill(
                    nextPayer,
                    bill.amount,
                    nextConsumers
                )
            )
        }

        this.bills = nextBills
        this.syncBillsWithParticipants()
        this.refreshBills()
        this.persistDraft()
    }

    func addBill() {
        let nextBills = ArrayList<Bill>(this.bills)
        nextBills.append(
            Bill(
                Person(""),
                0.0,
                ArrayList<Person>()
            )
        )
        let nextAmounts = ArrayList<String>(
            this.amountTexts
        )
        nextAmounts.append("")
        this.bills = nextBills
        this.amountTexts = nextAmounts
        this.persistDraft()
    }

    func removeBill(index: Int64) {
        if (index < 0 || index >= this.bills.size) {
            return
        }

        let nextBills = ArrayList<Bill>(this.bills)
        nextBills.remove(index)

        let nextAmounts = ArrayList<String>(
            this.amountTexts
        )
        if (index < nextAmounts.size) {
            nextAmounts.remove(index)
        }

        this.bills = nextBills
        this.amountTexts = nextAmounts
        this.persistDraft()
    }

    func selectPayer(billIndex: Int64, payerIndex: Int64) {
        if (billIndex < 0 || billIndex >= this.bills.size) {
            return
        }
        if (
            payerIndex < 0 ||
            payerIndex >= this.participants.size
        ) {
            return
        }

        this.bills[billIndex].payer =
            this.participants[payerIndex]
        this.refreshBills()
        this.persistDraft()
    }

    func toggleConsumer(
        billIndex: Int64,
        personIndex: Int64
    ) {
        if (billIndex < 0 || billIndex >= this.bills.size) {
            return
        }
        if (
            personIndex < 0 ||
            personIndex >= this.participants.size
        ) {
            return
        }

        let person = this.participants[personIndex]
        let bill = this.bills[billIndex]

        var target = -1
        for (i in 0..bill.consumers.size) {
            if (bill.consumers[i].name == person.name) {
                target = i
                break
            }
        }

        if (target >= 0) {
            bill.consumers.remove(target)
        } else {
            bill.consumers.append(person)
        }

        this.refreshBills()
        this.persistDraft()
    }

    func updateAmountText(index: Int64, value: String) {
        if (index < 0 || index >= this.amountTexts.size) {
            return
        }

        this.amountTexts[index] = value

        match (this.parseAmount(value)) {
            case Some(v) => this.bills[index].amount = v
            case None => this.bills[index].amount = 0.0
        }

        this.refreshBills()
        this.persistDraft()
    }

    func isPayerSelected(
        billIndex: Int64,
        payerIndex: Int64
    ): Bool {
        if (billIndex < 0 || billIndex >= this.bills.size) {
            return false
        }
        if (
            payerIndex < 0 ||
            payerIndex >= this.participants.size
        ) {
            return false
        }

        return this.bills[billIndex].payer.name ==
            this.participants[payerIndex].name
    }

    func isConsumerSelected(
        billIndex: Int64,
        personIndex: Int64
    ): Bool {
        if (billIndex < 0 || billIndex >= this.bills.size) {
            return false
        }
        if (
            personIndex < 0 ||
            personIndex >= this.participants.size
        ) {
            return false
        }

        let name = this.participants[personIndex].name
        for (consumer in this.bills[billIndex].consumers) {
            if (consumer.name == name) {
                return true
            }
        }
        return false
    }

    func amountTextAt(index: Int64): String {
        if (index < 0 || index >= this.amountTexts.size) {
            return ""
        }
        return this.amountTexts[index]
    }

    func syncBillsWithParticipants() {
        for (bill in this.bills) {
            if (this.participants.size == 0) {
                bill.payer = Person("")
                bill.consumers = ArrayList<Person>()
                continue
            }

            if (
                this.findParticipantIndex(
                    bill.payer.name
                ) < 0
            ) {
                bill.payer = Person("")
            }

            var cleaned = ArrayList<Person>()
            for (consumer in bill.consumers) {
                let idx = this.findParticipantIndex(
                    consumer.name
                )
                if (idx >= 0) {
                    let candidate = this.participants[idx]
                    if (
                        !this.containsName(
                            cleaned,
                            candidate.name
                        )
                    ) {
                        cleaned.append(candidate)
                    }
                }
            }
            bill.consumers = cleaned
        }
    }

    func findParticipantIndex(name: String): Int64 {
        var i = 0
        while (i < this.participants.size) {
            if (this.participants[i].name == name) {
                return i
            }
            i = i + 1
        }
        return -1
    }

    func participantIndexes(): ArrayList<Int64> {
        let indexes = ArrayList<Int64>()
        for (i in 0..this.participants.size) {
            indexes.append(i)
        }
        return indexes
    }

    func participantNames(): ArrayList<String> {
        let names = ArrayList<String>()
        for (p in this.participants) {
            names.append(p.name)
        }
        return names
    }

    func billIndexes(): ArrayList<Int64> {
        let indexes = ArrayList<Int64>()
        for (i in 0..this.bills.size) {
            indexes.append(i)
        }
        return indexes
    }

    func containsName(
        list: ArrayList<Person>,
        name: String
    ): Bool {
        for (item in list) {
            if (item.name == name) {
                return true
            }
        }
        return false
    }

    func parseAmount(text: String): Option<Float64> {
        try {
            return Some(Float64.parse(text))
        } catch (e: Exception) {
            return None
        }
    }

    func displayName(name: String): String {
        if (name.isEmpty() || name.isAsciiBlank()) {
            return "未命名"
        }
        return name
    }

    func validateParticipants(): Option<String> {
        if (this.participants.size == 0) {
            return Some("至少需要 1 个参与人")
        }

        var i = 0
        while (i < this.participants.size) {
            let name = this.participants[i].name

            if (name.isEmpty() || name.isAsciiBlank()) {
                return Some("参与人姓名不能为空")
            }

            var j = i + 1
            while (j < this.participants.size) {
                if (name == this.participants[j].name) {
                    return Some(
                        "参与人姓名不能重复"
                    )
                }
                j = j + 1
            }

            i = i + 1
        }

        return None
    }

    func validateBills(): Option<String> {
        if (this.bills.size == 0) {
            return Some("至少需要 1 笔账单")
        }

        var i = 0
        while (i < this.bills.size) {
            let bill = this.bills[i]

            if (
                bill.payer.name.isEmpty() ||
                bill.payer.name.isAsciiBlank() ||
                this.findParticipantIndex(
                    bill.payer.name
                ) < 0
            ) {
                return Some(
                    "每笔账单都必须选择付款人"
                )
            }

            if (i >= this.amountTexts.size) {
                return Some(
                    "每笔账单都必须填写金额"
                )
            }

            let raw = this.amountTexts[i]
            if (raw.isEmpty() || raw.isAsciiBlank()) {
                return Some(
                    "每笔账单都必须填写金额"
                )
            }

            match (this.parseAmount(raw)) {
                case Some(v) =>
                    if (v <= 0.0) {
                        return Some(
                            "账单金额必须大于0"
                        )
                    }
                    bill.amount = v
                case None =>
                    return Some("金额格式不正确")
            }

            if (bill.consumers.size == 0) {
                return Some(
                    "账单至少选1个消费者"
                )
            }

            for (consumer in bill.consumers) {
                if (
                    this.findParticipantIndex(
                        consumer.name
                ) < 0
                ) {
                    return Some(
                        "消费者不在参与人列表"
                    )
                }
            }

            i = i + 1
        }

        return None
    }

    func validateInput(): Option<String> {
        match (this.validateParticipants()) {
            case Some(msg) => return Some(msg)
            case None => ()
        }

        match (this.validateBills()) {
            case Some(msg) => return Some(msg)
            case None => ()
        }

        return None
    }

    func buildBillInput(): BillInput {
        let ps = ArrayList<Person>()
        for (p in this.participants) {
            ps.append(Person(p.name))
        }

        let bs = ArrayList<Bill>()
        for (bill in this.bills) {
            let payer = Person(bill.payer.name)
            let cs = ArrayList<Person>()
            for (consumer in bill.consumers) {
                cs.append(Person(consumer.name))
            }
            bs.append(Bill(payer, bill.amount, cs))
        }

        return BillInput(ps, bs)
    }

    func startSettlement() {
        this.showError = false
        this.errorMsg = ""

        match (this.validateInput()) {
            case Some(msg) =>
                this.showError = true
                this.errorMsg = msg
                return
            case None => ()
        }

        let solver = SettlementSolver()
        let input = this.buildBillInput()
        let result = solver.settle(input)
        let dm = result.serialize()
        let jsonStr = dm.toJson().toJsonString()
        this.persistDraft()

        Router.push(
            url: "SettlementPage",
            params: jsonStr
        )
    }

    func persistDraft() {
        AppSession.saveBillEntryDraft(
            this.participants,
            this.bills,
            this.amountTexts
        )
    }

    func refreshParticipants() {
        this.participants = ArrayList<Person>(
            this.participants
        )
    }

    func refreshBills() {
        this.bills = ArrayList<Bill>(this.bills)
        this.amountTexts = ArrayList<String>(
            this.amountTexts
        )
    }
}
