/**
 * Created on 2026/5/2
 */
package ohos_app_cangjie_entry.logic

import ohos_app_cangjie_entry.model.*

import std.collection.*
import std.sort.*
import std.math.min

public class SettlementSolver {

    // ==================== 第一步：计算净余额 ====================
    // 输入：完整的账单输入
    // 输出：每个人的净余额（正数表示应收，负数表示应付）
    public func computeNetBalances(input: BillInput): HashMap<Person, Float64> {
        var balances = HashMap<Person, Float64>()

        // 初始化所有参与者余额为0
        for (person in input.participants) {
            balances.put(person, 0.0)
        }

        // 逐笔账单处理
        for (bill in input.bills) {
            let payer = bill.payer
            let amount = bill.amount
            let consumers = bill.consumers

            // 付款人先支出全部金额（减少余额）
            // 注意：付款人也是消费者之一，会通过平摊加回来
            balances[payer] = balances[payer] + amount

            // 计算每人应付金额
            let shareCount = consumers.size
            if (shareCount == 0) {
                continue  // 没有消费者，跳过
            }
            let shareAmount = amount / Float64(shareCount)

            // 每个消费者平摊
            for (consumer in consumers) {
                balances[consumer] = balances[consumer] - shareAmount
            }
        }

        return balances
    }

    // ==================== 第二步：最小化转账次数 ====================
    // 输入：净余额映射
    // 输出：最少次数的转账列表
    public func minimizeTransfers(balances: HashMap<Person, Float64>): ArrayList<Transfer> {
        // 分离债务人和债权人
        var debtors = ArrayList<(Person, Float64)>()   // 应付（负余额，存正数）
        var creditors = ArrayList<(Person, Float64)>() // 应收（正余额）

        for ((person, balance) in balances) {
            // 忽略余额为0的人
            if (balance < -0.01) {
                debtors.append((person, -balance))  // 存正数，表示欠款金额
            } else if (balance > 0.01) {
                creditors.append((person, balance))
            }
        }

        // 按金额降序排序（大额优先，减少转账次数）
        debtors.sortBy(stable: false, comparator: {a: (Person, Float64), b: (Person, Float64) =>
            if (a[1] > b[1]) {
                return Ordering.LT
            } else if (a[1] == b[1]) {
                return Ordering.EQ
            } else {
                return Ordering.GT
            }
        })
        creditors.sortBy(stable: false, comparator: {a: (Person, Float64), b: (Person, Float64) =>
            if (a[1] > b[1]) {
                return Ordering.LT
            } else if (a[1] == b[1]) {
                return Ordering.EQ
            } else {
                return Ordering.GT
            }
        })

        var transfers = ArrayList<Transfer>()
        var i = 0  // debtors 索引
        var j = 0  // creditors 索引

        while (i < debtors.size && j < creditors.size) {
            let debtor = debtors[i]   // 欠钱的人
            let creditor = creditors[j]  // 被欠钱的人

            // 本次转账金额（取较小的那个）
            let amount = min(debtor[1], creditor[1])

            if (amount > 0.01) {
                transfers.append(Transfer(debtor[0], creditor[0], amount))
            }

            // 更新剩余金额
            debtors[i] = (debtor[0], debtor[1] - amount)
            creditors[j] = (creditor[0], creditor[1] - amount)

            // 移动指针（如果剩余金额为0）
            if (debtors[i][1] < 0.01) {
                i++
            }
            if (creditors[j][1] < 0.01) {
                j++
            }
        }

        return transfers
    }

    public func settle(input: BillInput): SettlementResult {
        // 计算净余额
        let balances = this.computeNetBalances(input)

        // 将 Person 转 String 用于调试显示
        let balanceDisplay = HashMap<String, Float64>()
        for ((person, balance) in balances) {
            balanceDisplay.put(person.name, balance)
        }

        // 计算最小转账
        let transfers = this.minimizeTransfers(balances)

        return SettlementResult(transfers, balanceDisplay)
    }
}