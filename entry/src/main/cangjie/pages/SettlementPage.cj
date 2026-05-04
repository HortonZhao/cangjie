/**
 * Created on 2026/5/3
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

    // 接收路由传递的参数
    public func aboutToAppear() {
        let params = Router.getParams().getOrDefault({ => "" })
        let jv = JsonValue.fromStr(params)
        let dm = DataModel.fromJson(jv)
        let result = SettlementResult.deserialize(dm)
        this.transfers = result.transfers
        this.balances = result.balances
        this.paidTotals = result.paidTotals
        this.consumedTotals = result.consumedTotals
    }

    func build() {
        Column {
            // 标题
            Text("结算结果")
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin(top: 20, bottom: 10)

            // 净余额展示区
            Text("各人净余额")
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .margin(left: 15, top: 10, bottom: 10)

            // 先展示净余额
            Row {
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
                        buildTransferRow(transfers.get(0).getOrThrow())
                        buildTransferRow(transfers.get(1).getOrThrow())
                        buildTransferRow(transfers.get(2).getOrThrow())
                        buildTransferRow(transfers.get(3).getOrThrow())
//                        for (t in this.transfers) {
//                            buildTransferRow(t)
//                        }
                    }
                    .width(100.percent)
                }
                .width(100.percent)
                .height(300)
            }

            // 返回按钮
            Button("返回编辑")
                .onClick { _ =>
                    Router.back()
                }
                .fontSize(16)
                .height(45)
                .width(70.percent)
                .margin(top: 20, bottom: 20)
                .backgroundColor(Color.GRAY)
                .fontColor(Color.WHITE)
                .borderRadius(22)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(Color(0xFFF5F5F5))
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
                .width(100)
            if (balance > 0.0) {
                Text("应收 ¥${this.formatAmount(balance)}")
                    .fontSize(16)
                    .fontColor(Color.GREEN)
            } else if (balance < 0.0) {
                Text("应付 ¥${this.formatAmount(-balance)}")
                    .fontSize(16)
                    .fontColor(Color.RED)
            } else {
                Text("已结清")
                    .fontSize(16)
                    .fontColor(Color.GRAY)
            }
        }
        .width(100.percent)
        .height(40)
        .padding(left: 20)
    }

    @Builder
    func buildTransferRow(transfer: Transfer) {
        Row {
            Text("${transfer.from.name}")
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
            Text(" → ")
                .fontSize(16)
            Text("${transfer.to.name}")
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
            Text("  ¥${this.formatAmount(transfer.amount)}")
                .fontSize(16)
                .fontColor(Color.RED)
                .fontWeight(FontWeight.Bold)
        }
        .width(100.percent)
        .height(45)
        .padding(left: 20)
        .margin(bottom: 5)
        .backgroundColor(Color.WHITE)
        .borderRadius(8)
    }

    func formatAmount(amount: Float64): String {
        let rounded = round(amount * 100.0) / 100.0
        return "${rounded}"
    }
}