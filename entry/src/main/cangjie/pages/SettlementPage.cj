package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router

import ohos_app_cangjie_entry.model.*
import ohos_app_cangjie_entry.state.AppSession

import std.collection.*
import std.math.round
import encoding.json.*
import serialization.serialization.*

@Entry
@Component
class SettlementPage {
    @State
    var transfers: ArrayList<Transfer> = ArrayList<Transfer>()

    @State
    var balances: HashMap<String, Float64> = HashMap<String, Float64>()

    @State
    var paidTotals: HashMap<String, Float64> = HashMap<String, Float64>()

    @State
    var consumedTotals: HashMap<String, Float64> = HashMap<String, Float64>()

    @State
    var participantNames: ArrayList<String> = ArrayList<String>()

    public func aboutToAppear() {
        let paramStr = Router.getParams().getOrDefault({ => "" })
        if (paramStr.isEmpty()) {
            return
        }

        let jv = JsonValue.fromStr(paramStr)
        let dm = DataModel.fromJson(jv)
        let result = SettlementResult.deserialize(dm)
        this.transfers = result.transfers
        this.balances = result.balances
        this.paidTotals = result.paidTotals
        this.consumedTotals = result.consumedTotals
        this.participantNames = this.resolveParticipantNames(result)
    }

    func build() {
        Column {
            Row {}
                .width(100.percent)
                .height(2)
                .backgroundColor(Color(0x30533AFD))
                .margin(bottom: 12)

            Scroll {
                Column {
                    this.buildHeader()
                    this.buildBalanceSection()
                    this.buildAmountSection("支付统计", this.paidTotals)
                    this.buildAmountSection("消费统计", this.consumedTotals)
                    this.buildTransferSection()

                    Button("返回编辑")
                        .onClick { _ => Router.back() }
                        .fontSize(16)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(Color.WHITE)
                        .height(44)
                        .width(75.percent)
                        .borderRadius(4)
                        .backgroundColor(Color(0xFF533AFD))
                        .margin(bottom: 12)

                    Button("重新开始")
                        .onClick { _ =>
                            this.restartSettlement()
                        }
                        .fontSize(16)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(Color(0xFF533AFD))
                        .height(44)
                        .width(75.percent)
                        .borderRadius(4)
                        .borderWidth(1)
                        .borderColor(Color(0xFF533AFD))
                        .backgroundColor(Color.WHITE)
                        .margin(bottom: 30)
                }
                .width(100.percent)
            }
            .width(100.percent)
            .height(100.percent)
            .layoutWeight(1)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(Color(0xFFF4F6FC))
    }

    @Builder
    func buildHeader() {
        Column {
            Text("结算结果")
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color(0xFF061B31))
                .margin(bottom: 6)

            Text("查看净余额、支付统计和转账方案")
                .fontSize(14)
                .fontColor(Color(0xFF64748D))
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(left: 16, right: 16, top: 8, bottom: 18)
    }

    @Builder
    func buildBalanceSection() {
        Column {
            Text("净余额")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color(0xFF061B31))
                .margin(bottom: 12)

            if (this.participantNames.size == 0) {
                this.buildEmptyState("暂无结算数据")
            } else {
                Column {
                    ForEach(
                        this.participantNames,
                        itemGeneratorFunc: {
                            item: String,
                            tag: Int64 =>
                                this.buildBalanceRow(
                                    item,
                                    this.amountOf(this.balances, item)
                                )
                        }
                    )
                }
                .width(100.percent)
            }
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(16)
        .backgroundColor(Color.WHITE)
        .borderRadius(8)
        .margin(left: 16, right: 16, bottom: 16)
    }

    @Builder
    func buildAmountSection(title: String, amounts: HashMap<String, Float64>) {
        Column {
            Text(title)
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color(0xFF061B31))
                .margin(bottom: 12)

            if (this.participantNames.size == 0) {
                this.buildEmptyState("暂无统计数据")
            } else {
                Column {
                    ForEach(
                        this.participantNames,
                        itemGeneratorFunc: {
                            item: String,
                            tag: Int64 =>
                                this.buildAmountRow(
                                    item,
                                    this.amountOf(amounts, item)
                                )
                        }
                    )
                }
                .width(100.percent)
            }
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(16)
        .backgroundColor(Color.WHITE)
        .borderRadius(8)
        .margin(left: 16, right: 16, bottom: 16)
    }

    @Builder
    func buildTransferSection() {
        Column {
            Text("转账方案（共${this.transfers.size}笔）")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color(0xFF061B31))
                .margin(bottom: 12)

            if (this.transfers.size == 0) {
                this.buildEmptyState("无需转账，当前已经结清")
            } else {
                Column {
                    ForEach(
                        this.transferIndexes(),
                        itemGeneratorFunc: {
                            item: Int64,
                            tag: Int64 =>
                                this.buildTransferRow(
                                    this.transfers.get(item).getOrThrow()
                                )
                        }
                    )
                }
                .width(100.percent)
            }
        }
        .width(100.percent)
        .alignItems(HorizontalAlign.Start)
        .padding(16)
        .backgroundColor(Color.WHITE)
        .borderRadius(8)
        .margin(left: 16, right: 16, bottom: 24)
    }

    @Builder
    func buildEmptyState(message: String) {
        Text(message)
            .fontSize(15)
            .fontColor(Color(0xFF8E8E93))
            .margin(top: 4, bottom: 4)
    }

    @Builder
    func buildAmountRow(name: String, amount: Float64) {
        Row {
            Text(name)
                .fontSize(16)
                .fontColor(Color(0xFF061B31))
                .layoutWeight(1)

            Text("CNY ${this.formatAmount(amount)}")
                .fontSize(16)
                .fontColor(Color(0xFF333333))
        }
        .width(100.percent)
        .padding(top: 10, bottom: 10)
    }

    @Builder
    func buildBalanceRow(name: String, balance: Float64) {
        Row {
            Text(name)
                .fontSize(16)
                .fontWeight(FontWeight.W400)
                .fontColor(Color(0xFF061B31))
                .layoutWeight(1)

            if (balance > 0.0) {
                Text("应收")
                    .fontSize(13)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF15BE53))
                    .margin(right: 6)
                Text("CNY ${this.formatAmount(balance)}")
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color(0xFF15BE53))
            } else if (balance < 0.0) {
                Text("应付")
                    .fontSize(13)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF64748D))
                    .margin(right: 6)
                Text("CNY ${this.formatAmount(-balance)}")
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color(0xFF64748D))
            } else {
                Text("已结清")
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF8E8E93))
            }
        }
        .width(100.percent)
        .padding(top: 10, bottom: 10)
    }

    @Builder
    func buildTransferRow(transfer: Transfer) {
        Column {
            Row {
                Text(transfer.from.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF061B31))
                    .layoutWeight(1)

                Text("->")
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF64748D))

                Text(transfer.to.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF061B31))
                    .layoutWeight(1)

                Text("CNY ${this.formatAmount(transfer.amount)}")
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color(0xFF533AFD))
                    .margin(left: 12)
            }
            .width(100.percent)
            .padding(top: 14, bottom: 14, left: 8, right: 8)
        }
        .width(100.percent)
        .backgroundColor(Color(0xFAFFFFFF))
        .borderRadius(6)
        .margin(bottom: 8)
        .padding(1)
    }

    func resolveParticipantNames(result: SettlementResult): ArrayList<String> {
        let names = ArrayList<String>()
        for (name in result.participantNames) {
            this.appendNameIfMissing(names, name)
        }
        for ((name, _) in result.balances) {
            this.appendNameIfMissing(names, name)
        }
        for ((name, _) in result.paidTotals) {
            this.appendNameIfMissing(names, name)
        }
        for ((name, _) in result.consumedTotals) {
            this.appendNameIfMissing(names, name)
        }
        return names
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

    func amountOf(amounts: HashMap<String, Float64>, name: String): Float64 {
        return amounts.get(name).getOrDefault({ => 0.0 })
    }

    func transferIndexes(): ArrayList<Int64> {
        let indexes = ArrayList<Int64>()
        for (i in 0..this.transfers.size) {
            indexes.append(i)
        }
        return indexes
    }

    func formatAmount(amount: Float64): String {
        let rounded = round(amount * 100.0) / 100.0
        return "${rounded}"
    }

    func restartSettlement() {
        let resetToken = AppSession.restartBillEntry()
        Router.back(
            url: "StartPage",
            params: resetToken
        )
    }
}
