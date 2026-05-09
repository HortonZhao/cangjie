package ohos_app_cangjie_entry.pages

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.Router

import ohos_app_cangjie_entry.state.AppSession

@Entry
@Component
class StartPage {
    func build() {
        Column {
            Column {
                Text("智能 AA 记账本")
                    .fontSize(32)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color(0xFF061B31))
                    .margin(bottom: 24)

                Button("开始记账")
                    .onClick { _ =>
                        this.startNewBillEntry()
                    }
                    .width(100.percent)
                    .height(48)
                    .fontSize(17)
                    .fontColor(Color.WHITE)
                    .backgroundColor(Color(0xFF2767F7))
                    .borderRadius(8)
            }
            .width(100.percent)
            .padding(left: 24, right: 24, top: 36, bottom: 24)
            .backgroundColor(Color(0xFFF8FAFD))
            .borderRadius(16)
        }
        .width(100.percent)
        .height(100.percent)
        .justifyContent(FlexAlign.Center)
        .padding(left: 18, right: 18)
        .backgroundColor(Color(0xFFEFF4FF))
    }

    func startNewBillEntry() {
        let resetToken = AppSession.restartBillEntry()
        Router.push(
            url: "BillEntryPage",
            params: resetToken
        )
    }
}
