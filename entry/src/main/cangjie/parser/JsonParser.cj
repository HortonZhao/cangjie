/**
 * Created on 2026/5/2
 */
package ohos_app_cangjie_entry.parser
import ohos_app_cangjie_entry.model.BillInput
import serialization.serialization.*
import encoding.json.*
import ohos.hilog.Hilog

public class JsonParser {
    public static func parseBillInput(str: String) : Option<BillInput> {
        try {
            var jv = JsonValue.fromStr(str)
            var dm = DataModel.fromJson(jv)
            Hilog.info(0, "Json", dm.toJson().asObject().toJsonString())
            var billInput = BillInput.deserialize(dm)
            return Some(billInput)
        } catch (e: Exception) {
            Hilog.info(0, "Json", "JSON 解析失败: ${e}")
            Hilog.info(0, "Json", "HELLO  ")
            return None
        }
    }

}