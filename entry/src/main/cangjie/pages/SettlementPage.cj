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
    var sortedNames: Array<String> = []

    public func aboutToAppear() {
        let paramStr = Router.getParams().getOrDefault({ => "" })
        if (paramStr.isEmpty()) { return }

        let jv = JsonValue.fromStr(paramStr)
        let dm = DataModel.fromJson(jv)
        let result = SettlementResult.deserialize(dm)
        this.transfers = result.transfers
        this.balances = result.balances

        // 提取人名排序
        let tmp = ArrayList<String>()
        let keys = this.balances.keys()
        for (k in keys) {
            tmp.append(k)
        }
        this.sortedNames = tmp.toArray()
    }

    func build() {
        Column {
            // 环境光条
            Row {}.width(100.percent).height(2).backgroundColor(Color(0x30533AFD)).margin(bottom: 12)

            Scroll {
                Column {
                    Text("结算结果")
                        .fontSize(34)
                        .fontWeight(FontWeight.Medium)
                        .fontColor(Color(0xFF061B31))
                        .margin(top: 16, bottom: 2)

                    Text("智能 AA 记账本")
                        .fontSize(16)
                        .fontWeight(FontWeight.W400)
                        .fontColor(Color(0xFF64748D))
                        .margin(bottom: 30)

                    // 净余额卡片
                    Column {
                        Row {}.width(100.percent).height(1).backgroundColor(Color(0x1A533AFD)).margin(bottom: 8)

                        Text("各人净余额")
                            .fontSize(22)
                            .fontWeight(FontWeight.Medium)
                            .fontColor(Color(0xFF061B31))
                            .margin(bottom: 18)

                        Column {
                            if (this.sortedNames.size > 0) {
                                buildBalanceRow(this.sortedNames[0], this.balances.get(this.sortedNames[0]).getOrThrow())
                            }
                            if (this.sortedNames.size > 1) {
                                buildBalanceRow(this.sortedNames[1], this.balances.get(this.sortedNames[1]).getOrThrow())
                            }
                            if (this.sortedNames.size > 2) {
                                buildBalanceRow(this.sortedNames[2], this.balances.get(this.sortedNames[2]).getOrThrow())
                            }
                            if (this.sortedNames.size > 3) {
                                buildBalanceRow(this.sortedNames[3], this.balances.get(this.sortedNames[3]).getOrThrow())
                            }
                            if (this.sortedNames.size > 4) {
                                buildBalanceRow(this.sortedNames[4], this.balances.get(this.sortedNames[4]).getOrThrow())
                            }
                            if (this.sortedNames.size > 5) {
                                buildBalanceRow(this.sortedNames[5], this.balances.get(this.sortedNames[5]).getOrThrow())
                            }
                            if (this.sortedNames.size > 6) {
                                buildBalanceRow(this.sortedNames[6], this.balances.get(this.sortedNames[6]).getOrThrow())
                            }
                            if (this.sortedNames.size > 7) {
                                buildBalanceRow(this.sortedNames[7], this.balances.get(this.sortedNames[7]).getOrThrow())
                            }
                            if (this.sortedNames.size > 8) {
                                buildBalanceRow(this.sortedNames[8], this.balances.get(this.sortedNames[8]).getOrThrow())
                            }
                            if (this.sortedNames.size > 9) {
                                buildBalanceRow(this.sortedNames[9], this.balances.get(this.sortedNames[9]).getOrThrow())
                            }
                            if (this.sortedNames.size > 10) {
                                buildBalanceRow(this.sortedNames[10], this.balances.get(this.sortedNames[10]).getOrThrow())
                            }
                            if (this.sortedNames.size > 11) {
                                buildBalanceRow(this.sortedNames[11], this.balances.get(this.sortedNames[11]).getOrThrow())
                            }
                            if (this.sortedNames.size > 12) {
                                buildBalanceRow(this.sortedNames[12], this.balances.get(this.sortedNames[12]).getOrThrow())
                            }
                            if (this.sortedNames.size > 13) {
                                buildBalanceRow(this.sortedNames[13], this.balances.get(this.sortedNames[13]).getOrThrow())
                            }
                            if (this.sortedNames.size > 14) {
                                buildBalanceRow(this.sortedNames[14], this.balances.get(this.sortedNames[14]).getOrThrow())
                            }
                        }
                    }
                    .padding(20)
                    .backgroundColor(Color.WHITE)
                    .borderRadius(8)
                    .margin(left: 16, right: 16, bottom: 28)

                    // 转账方案卡片
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
