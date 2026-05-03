# 智能AA记账本 - 后端接口文档

## 📁 代码结构(在 `entry\src\main\cangjie`中 )

logic/  
└── SettlementSolver.cj     # 核心结算算法

parser/  
└── JsonParser.cj           # JSON解析器，解析账单输入BillInput

model/  
└── BillModels.cj               # 数据模型（Person, Bill, 转账 Transfer, BillInput, 结算结果模型 SettlementResult）

pages/  
├── BillEntryPage.cj    入口界面  
└── SettlementPage.cj   结果展示界面

## 📦 数据模型 （详见`BillModels.cj`）

### Person
```cangjie
public class Person {
    public init(name: String)
    public mut prop name: String
}
```

### Bill
```cangjie
public class Bill {
    public init(payer: Person, amount: Float64, consumers: ArrayList<Person>)
    public mut prop payer: Person
    public mut prop amount: Float64
    public mut prop consumers: ArrayList<Person>
}
```

### BillInput
```cangjie
public class BillInput {
    public init(participants: ArrayList<Person>, bills: ArrayList<Bill>)
    public mut prop participants: ArrayList<Person>
    public mut prop bills: ArrayList<Bill>
}
```

### Transfer
```cangjie
public class Transfer {
    public init(from: Person, to: Person, amount: Float64)
    public mut prop from: Person
    public mut prop to: Person
    public mut prop amount: Float64
}
```

### SettlementResult
```cangjie
public class SettlementResult {
    public init(transfers: ArrayList<Transfer>, balances: HashMap<String, Float64>)
    public mut prop transfers: ArrayList<Transfer>
    public mut prop balances: HashMap<String, Float64>  // key: 人名, value: 净余额
}
```

## 🔧 核心算法 API

### SettlementSolver

```cangjie
public class SettlementSolver {
    // 一站式结算：输入账单，输出结算结果
    public func settle(input: BillInput): SettlementResult
    
    // 计算净余额（一般无需单独调用）
    public func computeNetBalances(input: BillInput): HashMap<Person, Float64>
    
    // 最小化转账（一般无需单独调用）
    public func minimizeTransfers(balances: HashMap<Person, Float64>): ArrayList<Transfer>
}
```

**使用示例：**
```cangjie
let solver = SettlementSolver()
let result = solver.settle(billInput)
// result.transfers: 转账列表
// result.balances: 每人净余额
```

### JsonParser

```cangjie
public class JsonParser {
    // JSON字符串 → BillInput 对象
    public static func parseBillInput(str: String): Option<BillInput>
}
```

**输入 JSON 格式：**
```json
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
```

## 📤 输出格式


# ！重要！
## 目前前端的`SettlementPage.cj`是有问题的，我不知道为什么仓颉不支持用for循环遍历生成组件（不知道是不是我IDE的问题），于是我用硬编码的方式将遍历的组件列出来了。
## 具体请看`SettlementPage.cj`中的`54-61`行和`85-91`行，一看就能明白问题在哪了。
## 目前我不知道有什么好的解决方法，就留在这了
## 另外，我给出的两个前端页面只是来展示接口的，不是真正的前端