/**
 * Created on 2026/5/2
 */
macro package ohos_app_cangjie_entry.utils

import std.ast.*

public macro property(attr: Tokens, input: Tokens): Tokens {
    let fieldNameStr = input.toString()
    let privateFieldNameStr = "_" + fieldNameStr
    let privateFieldName = Token(TokenKind.IDENTIFIER, privateFieldNameStr)
    
    return quote(
        public mut prop $(input): $(attr) {
            get() {
                return this.$(privateFieldName)
            }
            set(value) {
                this.$(privateFieldName) = value
            }
        }
    )
}