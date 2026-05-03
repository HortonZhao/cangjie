// BillEntryPage.cj
package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router
import ohos_app_cangjie_entry.logic.*
import ohos_app_cangjie_entry.model.*

import ohos_app_cangjie_entry.parser.*
import encoding.json.*
import serialization.serialization.*



@Entry
@Component
class BillEntryPage {
    @State var inputJson: String = """
{
  "participants": [
    {"name": "Alice"},
    {"name": "Bob"},
    {"name": "Charlie"},
    {"name": "David"},
    {"name": "Eve"}
  ],
  "bills": [
    {
      "payer": {"name": "Alice"},
      "amount": 120.5,
      "consumers": [
        {"name": "Alice"},
        {"name": "Bob"},
        {"name": "Charlie"}
      ]
    },
    {
      "payer": {"name": "Bob"},
      "amount": 75.0,
      "consumers": [
        {"name": "Bob"},
        {"name": "David"},
        {"name": "Eve"}
      ]
    },
    {
      "payer": {"name": "Charlie"},
      "amount": 60.0,
      "consumers": [
        {"name": "Alice"},
        {"name": "Charlie"},
        {"name": "Eve"}
      ]
    }
  ]
}
"""
    @State var showError: Bool = false
    @State var errorMsg: String = ""

    func build() {
        Column {
            // 标题
            Text("智能AA记账本")
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin(top: 20, bottom: 10)

            // 说明文字
            Text("请输入账单数据（JSON格式）")
                .fontSize(14)
                .fontColor(Color.GRAY)
                .margin(bottom: 10)

            // JSON 输入框
            TextArea(text: inputJson)
                .height(300)
                .width(95.percent)
                .borderRadius(8)
                .borderWidth(1)
                .borderColor(Color.GRAY)
                .backgroundColor(Color.WHITE)
                .fontSize(12)

            // 错误提示
            if (this.showError) {
                Text(this.errorMsg)
                    .fontSize(12)
                    .fontColor(Color.RED)
                    .margin(top: 10)
            }


            // 结算按钮
            Button("开始结算")
                .onClick{ _ => calculateAndNavigate() }
                .fontSize(18)
                .height(50)
                .width(80.percent)
                .margin(top: 30)
                .backgroundColor(Color.BLUE)
                .fontColor(Color.WHITE)
                .borderRadius(25)
        }
        .width(100.percent)
        .height(100.percent)
        .padding(15)
        .backgroundColor(Color(0xFFF5F5F5))
    }

    func calculateAndNavigate() {
        let solver = SettlementSolver()

        match (JsonParser.parseBillInput(this.inputJson)) {
            case Some(input) =>
                let result = solver.settle(input)
//                 跳转到结果页面，传递结果
                let dm = result.serialize()
                let jsonStr = dm.toJson().toJsonString()
                Router.push(url: "SettlementPage", params: jsonStr)
            case None =>
                this.showError = true
                this.errorMsg = "JSON 解析失败，请检查格式"
        }
    }
}