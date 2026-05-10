/**
 * 结算结果页 — Stripe 风格 + 稳定编译版
 * 使用已验证的 ArrayList/HashMap + @Builder 模式
 */
package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router
import ohos_app_cangjie_entry.logic.*
import ohos_app_cangjie_entry.model.*
import ohos_app_cangjie_entry.parser.*
import ohos_app_cangjie_entry.state.AppSession

import std.collection.*
import std.math.round
import encoding.json.*
import serialization.serialization.*

@Entry
@Component
class SettlementPage {
    @State var transfers: ArrayList<Transfer> = ArrayList()
    @State var balances: HashMap<String, Float64> = HashMap()

    @State var paidTotals: HashMap<String, Float64> = HashMap()
    @State var consumedTotals: HashMap<String, Float64> = HashMap()


    public func aboutToAppear() {
        let paramStr = Router.getParams().getOrDefault({ => "" })
        if (paramStr.isEmpty()) { return }

        let jv = JsonValue.fromStr(paramStr)
        let dm = DataModel.fromJson(jv)
        let result = SettlementResult.deserialize(dm)
        this.transfers = result.transfers
        this.balances = result.balances

        this.paidTotals = result.paidTotals
        this.consumedTotals = result.consumedTotals

    }

    func build() {
        Column {
            // 环境光条
            Row {}.width(100.percent).height(2).backgroundColor(Color(0x30533AFD)).margin(bottom: 12)

            Scroll {
                Column {

                    buildBalanceRow("Alice", balances.get("Alice").getOrThrow())
                    buildBalanceRow("Bob", balances.get("Bob").getOrThrow())
                    buildBalanceRow("Charlie", balances.get("Charlie").getOrThrow())
                    buildBalanceRow("David", balances.get("David").getOrThrow())
                    buildBalanceRow("Eve", balances.get("Eve").getOrThrow())
//                    for ((name, balance) in this.balances) {
//                        buildBalanceRow(name, balance)
//                    }
                }
                .width(100.percent)
            }
            .padding(10)
            .backgroundColor(Color.WHITE)
            .borderRadius(8)
            .margin(left: 15, right: 15)

            // 支付统计
            Text("支付统计")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin(left: 15, top: 20, bottom: 10)

            Row {
                Column {
                    buildAmountRow("Alice", paidTotals.get("Alice").getOrThrow())
                    buildAmountRow("Bob", paidTotals.get("Bob").getOrThrow())
                    buildAmountRow("Charlie", paidTotals.get("Charlie").getOrThrow())
                    buildAmountRow("David", paidTotals.get("David").getOrThrow())
                    buildAmountRow("Eve", paidTotals.get("Eve").getOrThrow())
                }
                .width(100.percent)
            }
            .padding(10)
            .backgroundColor(Color.WHITE)
            .borderRadius(8)
            .margin(left: 15, right: 15)

            // 消费统计
            Text("消费统计")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin(left: 15, top: 20, bottom: 10)

            Row {
                Column {
                    buildAmountRow("Alice", consumedTotals.get("Alice").getOrThrow())
                    buildAmountRow("Bob", consumedTotals.get("Bob").getOrThrow())
                    buildAmountRow("Charlie", consumedTotals.get("Charlie").getOrThrow())
                    buildAmountRow("David", consumedTotals.get("David").getOrThrow())
                    buildAmountRow("Eve", consumedTotals.get("Eve").getOrThrow())
                }
                .width(100.percent)
            }
            .padding(10)
            .backgroundColor(Color.WHITE)
            .borderRadius(8)
            .margin(left: 15, right: 15)

            // 转账列表
            Text("转账方案（共${this.transfers.size}笔）")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin(left: 15, top: 20, bottom: 10)

            // 转账列表
            if (this.transfers.size == 0) {
                Text("无需转账，已结清！")
                    .fontSize(16)
                    .fontColor(Color.GREEN)
                    .margin(top: 20)
            } else {
                Scroll {

                        
                    Column {
                        Row {}.width(100.percent).height(1).backgroundColor(Color(0x1A533AFD)).margin(bottom: 8)

                        Text("转账方案（共${this.transfers.size}笔）")
                            .fontSize(22)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(Color(0xFF061B31))
                            .margin(bottom: 16)

                        if (this.transfers.size == 0) {
                            Text("无需转账，已结清")
                                .fontSize(16)
                                .fontWeight(FontWeight.W400)
                                .fontColor(Color(0xFF15BE53))
                                .margin(top: 8, bottom: 8)
                        } else {
                            Column {
                                if (this.transfers.size > 0) {
                                    buildTransferRow(transfers.get(0).getOrThrow())
                                }
                                if (this.transfers.size > 1) {
                                    buildTransferRow(transfers.get(1).getOrThrow())
                                }
                                if (this.transfers.size > 2) {
                                    buildTransferRow(transfers.get(2).getOrThrow())
                                }
                                if (this.transfers.size > 3) {
                                    buildTransferRow(transfers.get(3).getOrThrow())
                                }
                                if (this.transfers.size > 4) {
                                    buildTransferRow(transfers.get(4).getOrThrow())
                                }
                                if (this.transfers.size > 5) {
                                    buildTransferRow(transfers.get(5).getOrThrow())
                                }
                                if (this.transfers.size > 6) {
                                    buildTransferRow(transfers.get(6).getOrThrow())
                                }
                                if (this.transfers.size > 7) {
                                    buildTransferRow(transfers.get(7).getOrThrow())
                                }
                                if (this.transfers.size > 8) {
                                    buildTransferRow(transfers.get(8).getOrThrow())
                                }
                                if (this.transfers.size > 9) {
                                    buildTransferRow(transfers.get(9).getOrThrow())
                                }
                                if (this.transfers.size > 10) {
                                    buildTransferRow(transfers.get(10).getOrThrow())
                                }
                                if (this.transfers.size > 11) {
                                    buildTransferRow(transfers.get(11).getOrThrow())
                                }
                                if (this.transfers.size > 12) {
                                    buildTransferRow(transfers.get(12).getOrThrow())
                                }
                                if (this.transfers.size > 13) {
                                    buildTransferRow(transfers.get(13).getOrThrow())
                                }
                                if (this.transfers.size > 14) {
                                    buildTransferRow(transfers.get(14).getOrThrow())
                                }
                                if (this.transfers.size > 15) {
                                    buildTransferRow(transfers.get(15).getOrThrow())
                                }
                                if (this.transfers.size > 16) {
                                    buildTransferRow(transfers.get(16).getOrThrow())
                                }
                                if (this.transfers.size > 17) {
                                    buildTransferRow(transfers.get(17).getOrThrow())
                                }
                                if (this.transfers.size > 18) {
                                    buildTransferRow(transfers.get(18).getOrThrow())
                                }
                                if (this.transfers.size > 19) {
                                    buildTransferRow(transfers.get(19).getOrThrow())
                                }
                            }
                        }
                    }
                    .padding(20)
                    .backgroundColor(Color.WHITE)
                    .borderRadius(8)
                    .margin(left: 16, right: 16, bottom: 32)

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
    func buildAmountRow(name: String, amount: Float64) {
        Row {
            Text(name)
                .fontSize(16)
                .width(100)
            Text("¥${this.formatAmount(amount)}")
                .fontSize(16)
                .fontColor(Color(0xFF333333))
        }
        .width(100.percent)
        .height(40)
        .padding(left: 20)
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
                Text("¥${this.formatAmount(balance)}")
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color(0xFF15BE53))
            } else if (balance < 0.0) {
                Text("应付")
                    .fontSize(13)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF64748D))
                    .margin(right: 6)
                Text("¥${this.formatAmount(-balance)}")
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
        .padding(top: 14, bottom: 14, left: 4, right: 4)
    }

    @Builder
    func buildTransferRow(transfer: Transfer) {
        Column {
            Row {
                Text("${transfer.from.name}")
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF061B31))
                    .layoutWeight(1)
                Text(" → ")
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF64748D))
                Text("${transfer.to.name}")
                    .fontSize(16)
                    .fontWeight(FontWeight.W400)
                    .fontColor(Color(0xFF061B31))
                    .layoutWeight(1)
                Text("¥${this.formatAmount(transfer.amount)}")
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color(0xFF533AFD))
                    .margin(left: 12)
            }
            .width(100.percent)
            .padding(top: 14, bottom: 14, left: 8, right: 8)
        }
        .backgroundColor(Color(0xFAFFFFFF))
        .borderRadius(6)
        .margin(bottom: 8)
        .padding(1)
    }

    func formatAmount(amount: Float64): String {
        let rounded = round(amount * 100.0) / 100.0
        return "${rounded}"
    }

    func restartSettlement() {
        let resetToken =
            AppSession.restartBillEntry()
        Router.back(
            url: "StartPage",
            params: resetToken
        )
    }
}
