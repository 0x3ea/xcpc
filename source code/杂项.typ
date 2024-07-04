#import "@preview/codly:0.2.0": *
#set page(
  footer: 
  [
    #h(1fr)
    #counter(page).display(
      "1/1",
      both: true,
    )
  ]
)
#set text(size: 13pt)
#show: codly-init.with()
#codly(languages: (cpp: (name: "", icon: (""), color: rgb("#FFFFFF")),))
#codly(
  zebra-color: white,
  stroke-width: 1pt,
  stroke-color: black,
  display-icon: false,
)
#set heading(
  numbering: "1.",
)
#outline(
  indent: 2em,
  title:"基础算法",
  depth: 4,//设置显示几级目录
  fill: line(length: 100%)
)
= 贪心

== 反悔堆

= 排序
== 归并排序
```cpp
void mergesort(int q[], int l, int r)
{
    if (l >= r)
        return;

    int mid = l + r >> 1;
    mergesort(q, l, mid);
    mergesort(q, mid + 1, r);
    int i = l, j = mid + 1, k = 0;
    while (i <= mid && j <= r)
    {
        if (q[i] <= q[j])
            tmp[k++] = q[i++];
        else
            tmp[k++] = q[j++];
    }
    while (i <= mid)
        tmp[k++] = q[i++];
    while (j <= r)
        tmp[k++] = q[j++];

    for (int i = l, j = 0; i <= r; i++, j++)
        q[i] = tmp[j];
}
```
== 快速排序

```cpp
void quicksort(int q[], int l, int r)
{
    if (l >= r)
        return;

    int i = l - 1, j = r + 1, x = q[l + r >> 1];
    while (i < j)
    {
        do
            i++;
        while (q[i] < x);
        do
            j--;
        while (q[j] > x);
        if (i < j)
            swap(q[i], q[j]);
    }
    quicksort(q, l, j);
    quicksort(q, j + 1, r);
}
```


基于快排的线性第K大
```cpp
void solve()
{
    int n, k;
    cin >> n >> k;
    k++;
    vector<int> a(n + 1);
    for (int i = 1; i <= n; i++)
        cin >> a[i];
    // 注意最小是第0小
    auto kth = [&](auto &kth, int l, int r) -> int
    {
        if (l == r && l == k)
            return a[k];
        int i = l, j = r;
        int tmp = a[l];
        while (i < j)
        {
            while (i < j && a[j] >= tmp)
                --j;
            if (i < j)
                swap(a[i], a[j]);
            while (i < j && a[i] <= tmp)
                ++i;
            if (i < j)
                swap(a[i], a[j]);
        }
        a[i] = tmp;
        if (i > k)
            return kth(kth, l, i - 1);
        else if (i < k)
            return kth(kth, i + 1, r);
        return a[k];
    };
    cout << kth(kth, 1, n) << endl;
}
```
== 倍增
=== 应用
- 求LCA
- 求k级祖先
- 维护路径信息(树上路径最小边权)
=== 例题

== 二分/三分

=== 二分
```cpp
int l = 1, r = n;
while (l < r)
{
    int mid = (l + r + 1) >> 1; // l+r>>1;
    if (check(mid))
        l = mid; // r=mid;
    else
        r = mid - 1; // l=mid+1;
}
```
=== 三分
==== 整数

整数的三分可能具有不确定性,可以通过改变while循环的条件为:
```cpp
while(l+5<r)
```
来缩小范围,再通过

```cpp
for(int i = l; i <= r; i++)
  ans = min(ans, calc(i));
for(int i = 1; i <= r; i++)
  ans = max(ans, calc(i));
//更新方式改成
l = lmid
r = rmid
```
来确定答案

凸函数的极大值
```cpp
ll l, r;
while (l < r) 
{
  ll lmid = l + (r - l) / 3;
	ll rmid = r - (r - l) / 3;
	if (calc(lmid) <= calc(rmid))
    l = lmid + 1;
	else
		r = rmid - 1;
}
printf("%lld\n", max(calc(l), calc(r)));
```

凹函数的极小值

```cpp
	ll l, r;
	while (l < r)
	{
		ll lmid = l + (r - l) / 3;
		ll rmid = r - (r - l) / 3;
		if (calc(rmid) >= calc(lmid))
			r = mid - 1;
		else
			l = mid + 1;
	}
	printf("%lld\n", min(calc(l), calc(r)));
```

==== 实数
凸函数的极大值
```cpp
db l, r;
for (int i = 0; i < 300; i++)
{
    db lmid = l + (r - l) / 3;
    db rmid = r - (r - l) / 3;
    if (calc(lmid) <= calc(rmid))
        l = lmid;
    else
        r = rmid;
}
printf("%.6f\n", calc(l))
```
凹函数的极小值
```cpp
db l, r;
for (int i = 0; i < 300; i++)
{
    db lmid = l + (r - l) / 3;
    db rmid = r - (r - l) / 3;
    if (calc(rmid) >= calc(lmid))
        r = rmid;
    else
        l = lmid;
}
printf("%.6f\n", calc(l));
```
- PS 三分要求在极小值左边和右边都是严格单调,三分整数时要注意
== 前缀和/差分
=== 普通前缀和
- 一维
```cpp
s[i] = s[i - 1] + a[i];
```
- 二维
```cpp
for (int i = 1; i <= n; i++)
    for (int j = 1; j <= m; j++)
        b[i][j] += b[i - 1][j] + b[i][j - 1] - b[i - 1][j - 1];
```
=== 普通差分
- 一维
```cpp
void add(int l,int r，int w)//区间加    
{
    s[l]+=w,s[r+1]-=w;
}
```
- 二维
```cpp
void add(int x1, int y1, int x2, int y2, int w)//给左上角为x1,y1，右下角为x2,y2的矩形区域加w
{
    b[x1][y1] += w;
    b[x2 + 1][y1] -= w;
    b[x1][y2 + 1] -= w;
    b[x2 + 1][y2 + 1] += w;
}
```
- 查询某一区域
```cpp
int query(int x1, int y1, int x2, int y2) // 给左上角为x1,y1，右下角为x2,y2的矩形区域
{
    return s[x2][y2] - s[x1 - 1][y2] - s[x2][y1 - 1] + s[x1 - 1][y1 - 1];
}
```
=== 树上前缀和
- 点权
x,y路径上的点权之和s[x]+s[y]-s[lca]-s[f(lca)]
```cpp
int query(int a, int b)
{
    int u=lca(a,b);
    return s[a] + s[b] - s[u] - s[f[u][0];
}
```
- 边权
把边权当作点权处理，边权加到深度更深的点上
```cpp
(dist[u] > dist[v]) ? (s[u] += w, e[u] = w) : (s[v] += w, e[v] = w);//一定要加括号！
```
x,y路径上的边权和为s[x]+s[y]-2*s[lca]
```cpp
int query(int a, int b)
{
    return s[a] + s[b] - 2 * s[lca(a, b)];
}
```
=== 树上差分
- 点权
x,y路径上所有点+w

d[x]+=w,d[y]+=w,d[lca]-=w,d[fa(lca)]-=w
```cpp
void modify(int a, int b,int w)
{
    int u=lca(a,b);
    d[a]+=w, d[b]+=w, d[u] -= w,d[f[u][0] -= w;
}
```
- 边权
x,y路径上所有边+w

d[x]+=w,d[y]+=w,d[lca]-=2*w
```cpp
void modify(int a, int b, int w)
{
    d[a] += w, d[b] += w, d[lca(a, b)] -= 2 * w;
}
```
差分后做前缀和求答案
```cpp
void cal(int u, int fa)
{
    for (auto to : edge[u])
        if (to != fa)
        {
            cal(to, u);
            d[u] += d[to];
        }
}
```
- 利用dfs序进行树上差分


=== 应用
- 利用前缀和降低维度
https://qoj.ac/problem/4195

在给定字母矩阵中找到同时含有WALDO的最小矩阵，输出面积
```cpp
int n, m;
int cnt[10];
int inv[N];
map<char, int> mp;
void solve()
{
    mp['W'] = 1;
    mp['A'] = 2;
    mp['L'] = 3;
    mp['D'] = 4;
    mp['O'] = 5;
    cin >> n >> m;
    ll ans = LLONG_MAX;
    vector<vector<char>> a(max(n, m) + 10, vector<char>(min(n, m) + 10, '0'));
    if (n < m)
    {
        for (int i = n; i >= 1; i--)
            for (int j = 1; j <= m; j++)
                cin >> a[j][i];
        swap(n, m);
    }
    else
    {
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= m; j++)
                cin >> a[i][j];
    }
    for (int l = 1; l <= m; l++)
    {
        for (int i = 1; i <= n; i++)
            inv[i] = 0;
        for (int r = l; r <= m; r++)
        {
            for (int j = 1; j <= n; j++)
            {
                if (a[j][r] == 'W' || a[j][r] == 'A' || a[j][r] == 'L' || a[j][r] == 'D' || a[j][r] == 'O')
                    inv[j] |= (1 << mp[a[j][r]]);
            }
            // 双指针求满足条件的最小区间
            memset(cnt, 0, sizeof cnt);
            int le = 1, now = 0;
            for (int ri = 1; ri <= n; ri++) // 枚举右端点
            {
                for (int k = 1; k <= 5; k++)
                {
                    if ((inv[ri] >> k) & 1)
                    {
                        cnt[k]++;
                        if (cnt[k] == 1)
                            now++;
                    }
                }
                while (now == 5)
                {
                    ll res = (r - l + 1) * (ri - le + 1);
                    ans = min(ans, res);
                    for (int k = 1; k <= 5; k++)
                    {
                        if ((inv[le] >> k) & 1)
                        {
                            cnt[k]--;
                            if (cnt[k] == 0)
                                now--;
                        }
                    }
                    le++;
                }
            }
        }
    }
    if (ans > n * m)
        cout << "impossible" << endl;
    else
        cout << ans << endl;
}
```
== 扫描线

== 高精度

1.自用
```cpp
struct bign {
    vector<short> a;
    int sign;
    bign() : sign(1) {}
    bign(ll num) : sign(1) { *this = num; }
    bign(string &s) : sign(1) {
        for (int i = (int)s.size() - 1; i >= 0; i--)
            a.push_back(s[i] - '0');
    }
    bign &up() {
        while (a.size() > 1 && !a.back())
            a.pop_back(); // 去除前导零
        for (int i = 1; i < a.size(); i++) {
            a[i] += a[i - 1] / 10;
            a[i - 1] %= 10;
        }
        while (a.back() >= 10) {
            a.push_back(a.back() / 10);
            a[(int)a.size() - 2] %= 10;
        }
        return *this;
    }
    bign operator=(const bign T) {
        a = T.a;
        sign = T.sign;
        return *this;
    }
    bign operator=(ll num) {
        sign = num < 0 ? -1 : 1;
        num = abs(num);
        a.clear();
        while (num)
            a.push_back(num % 10), num /= 10;
        return *this;
    }
    bign &operator+=(const bign &T) {
        if (a.size() < T.a.size())
            a.resize(T.a.size());
        for (int i = 0; i < T.a.size(); i++)
            a[i] += T.a[i];
        return this->up();
    }
    bign operator+(const bign &T) const {
        if (this->sign != T.sign) {
            if (this->sign == -1) {
                return T + *this;
            } else {
                return *this - T;
            }
        }
        bign ans;
        ans.sign = T.sign;
        ans.a.resize(max(a.size(), T.a.size()));
        for (int i = 0; i < max(a.size(), T.a.size()); i++) {
            if (i < a.size())
                ans.a[i] += a[i];
            if (i < T.a.size())
                ans.a[i] += T.a[i];
        }
        return ans.up();
    }
    bign operator*(const bign &T) const {
        bign ans;
        ans.a.resize(a.size() + T.a.size());
        for (int i = 0; i < T.a.size(); i++)
            for (int j = 0; j < a.size(); j++)
                ans.a[i + j] += (a[j] * T.a[i]);
        return ans.up();
    }
    bign operator-(const bign &T) const {
        bign ans;
        if (*this < T) {
            ans = T - *this;
            ans.sign = -1;
        } else {
            for (int i = 0, t = 0; i < a.size(); i++) {
                t = a[i] - t;
                if (i < T.a.size())
                    t -= T.a[i];
                ans.a.push_back((t + 10) % 10);
                if (t < 0)
                    t = 1;
                else
                    t = 0;
            }
        }
        return ans.up();
    }
    bign operator/(const bign &T) const {
        ll i, j;
        bign ans = 0, c = *this;
        for (i = (int)a.size() - 1; i >= 0; i--) {
            ans = ans * 10 + a[i];
            for (j = 0; j < 10; j++)
                if (ans < T * (j + 1))
                    break;
            c.a[i] = j;
            ans = ans - T * j;
        }
        return c.up();
    }
    bign operator%(const bign &T) {
        int i, j;
        bign ans = 0;
        for (i = (int)a.size() - 1; i >= 0; i--) {
            ans = ans * 10 + a[i];
            for (j = 0; j < 10; j++)
                if (ans < T * (j + 1))
                    break;
            ans = ans - T * j;
        }
        return ans;
    }
    bool operator<(const bign &T) const {
        if (a.size() != T.a.size())
            return a.size() < T.a.size();
        for (int i = a.size() - 1; i >= 0; --i)
            if (a[i] != T.a[i])
                return a[i] < T.a[i];
        return 0;
    }
    bool operator>(const bign &T) const { return T < *this; }
    bool operator<=(const bign &b) const { return !(b < *this); }
    bool operator>=(const bign &b) const { return !(*this < b); }
    bool operator!=(const bign &b) const { return b < *this || *this < b; }
    bool operator==(const bign &b) const { return !(b < *this) && !(b > *this); }

    bool operator>(bign &T) {
        return T < *this;
    }
    friend istream &operator>>(istream &is, bign &T) {
        string s;
        is >> s;
        T.a.clear();
        if (s[0] == '-')
            T.sign = -1;
        for (int i = (int)s.size() - 1; i >= (T.sign != 1); i--)
            T.a.push_back(s[i] - '0');
        return is;
    }
    friend ostream &operator<<(ostream &os, const bign &T) {
        if (T.sign == -1)
            os << '-';
        for (int i = (int)T.a.size() - 1; i >= 0; i--)
            os << T.a[i];
        return os;
    }
};
```
])
2.
```cpp
const int LEN = 100009;
struct BIGNUM {

    static const int BIT = 9;
    static const int MOD = 1e9; // 1eBIT 14
    bool flag;                  // 0 for 0 or positive, 1 for negative
    ll s[LEN];
    BIGNUM() {
        flag = 0;
        memset(s, 0, sizeof(s));
        s[0] = 1;
    }
    void init() { // 数组清零
        memset(s, 0, sizeof(s));
    }
    void print() { // 打印
        BIGNUM a = *this;
        if (a.flag) {
            printf("-");
        }
        printf("%lld", a.s[a.s[0]]);
        for (int i = a.s[0] - 1; i > 0; i--) {
            printf("%09lld", a.s[i]);
        }
        printf("\n");
    }
    BIGNUM operator=(const char *num) {
        if (num[0] == '-') {
            flag = 1;
            num++;
        } else if (num[0] == '+') {
            flag = 0;
            num++;
        }
        int l = strlen(num);
        s[0] = 0;
        for (int i = l - 1; i > -9; i -= 9) {
            int temp = 0;
            for (int j = i - 8; j <= i; j++) {
                if (j < 0)
                    continue;
                else {
                    temp = (temp << 1) + (temp << 3);
                    temp += num[j] ^ 48;
                }
            }
            s[++s[0]] = temp;
        }
        while (!s[s[0]] && s[0] > 1)
            s[0]--;
        return *this;
    }
    BIGNUM operator=(const int num) {
        char a[LEN];
        sprintf(a, "%d", num);
        *this = a;
        return *this;
    }
    BIGNUM(int num) { *this = num; }
    BIGNUM(const char *num) { *this = num; }
    bool operator<(const BIGNUM &a) {
        if (flag > a.flag)
            return 1;
        else if (flag < a.flag)
            return 0;
        else {
            if ((s[0] < a.s[0] && (!flag)) || (s[0] > a.s[0] && flag))
                return 1;
            else if (s[0] != a.s[0])
                return 0;
            else {
                for (int i = s[0]; i > 0; i--) {
                    if (s[i] < a.s[i]) {
                        if (flag)
                            return 0;
                        else
                            return 1;
                    } else if (s[i] > a.s[i]) {
                        if (flag)
                            return 1;
                        else
                            return 0;
                    }
                }
                return 0;
            }
        }
    }
    bool operator>(const BIGNUM &a) {
        if (flag > a.flag)
            return 0;
        else if (flag < a.flag)
            return 1;
        else {
            if ((s[0] > a.s[0] && (!flag)) || (s[0] < a.s[0] && flag))
                return 1;
            else if (s[0] != a.s[0]) {
                return 0;
            } else {
                for (int i = s[0]; i > 0; i--) {
                    if (s[i] > a.s[i]) {
                        if (flag)
                            return 0;
                        else
                            return 1;
                    } else if (s[i] < a.s[i]) {
                        if (flag)
                            return 1;
                        else
                            return 0;
                    }
                }
                return 0;
            }
        }
    }
    bool operator==(const BIGNUM &a) {
        if (flag != a.flag)
            return 0;
        else {
            if (s[0] != a.s[0])
                return 0;
            else {
                for (int i = s[0]; i > 0; i--) {
                    if (s[i] != a.s[i])
                        return 0;
                }
                return 1;
            }
        }
    }
    bool operator>=(const BIGNUM &a) {
        if (*this > a || *this == a)
            return 1;
        return 0;
    }
    bool operator<=(const BIGNUM &a) {
        return (*this == a) || (*this < a);
    }
    int cmp_abs(const BIGNUM &a) { // 1 for this > a, 0 for this == a, -1 for this < a
        if (s[0] > a.s[0])
            return 1;
        else if (s[0] < a.s[0])
            return -1;
        else {
            for (int i = s[0]; i > 0; i--) {
                if (s[i] > a.s[i])
                    return 1;
                else if (s[i] < a.s[i])
                    return -1;
            }
        }
        return 0;
    }
    BIGNUM operator+(const BIGNUM &B) {
        BIGNUM c, a = *this, b = B;
        if (!(a.flag || b.flag) || (a.flag && b.flag)) {
            c.flag = a.flag;
            int x = 0;
            c.s[0] = max(a.s[0], b.s[0]) + 1;
            for (int i = 1; i <= c.s[0]; i++) {
                c.s[i] = a.s[i] + b.s[i] + x;
                x = c.s[i] / MOD;
                c.s[i] %= MOD;
            }
        } else if (a.flag) {         // a < 0
            if (a.cmp_abs(b) == 1) { //|a| > |b|, |ans| = |a| - |b|
                c.flag = 1;
                c.s[0] = max(a.s[0], b.s[0]) + 1;
                for (int i = 1; i <= c.s[0]; i++) {
                    c.s[i] = a.s[i] - b.s[i];
                    if (c.s[i] < 0) {
                        c.s[i] += MOD;
                        a.s[i + 1]--;
                    }
                }
            } else { //|a| <= |b|, |ans| = |b| - |a|
                c.flag = 0;
                c.s[0] = max(a.s[0], b.s[0]) + 1;
                for (int i = 1; i <= c.s[0]; i++) {
                    c.s[i] = b.s[i] - a.s[i];
                    if (c.s[i] < 0) {
                        c.s[i] += MOD;
                        b.s[i + 1]--;
                    }
                }
            }
        } else {                     // b < 0
            if (b.cmp_abs(a) == 1) { // |b| > |a|, |ans| = |b| - |a|
                c.flag = 1;
                c.s[0] = max(a.s[0], b.s[0]) + 1;
                for (int i = 1; i <= c.s[0]; i++) {
                    c.s[i] = b.s[i] - a.s[i];
                    if (c.s[i] < 0) {
                        c.s[i] += MOD;
                        b.s[i + 1]--;
                    }
                }
            } else { //|b| <= |a|, |ans| = |a| - |b|
                c.flag = 0;
                c.s[0] = max(a.s[0], b.s[0]) + 1;
                for (int i = 1; i <= c.s[0]; i++) {
                    c.s[i] = a.s[i] - b.s[i];
                    if (c.s[i] < 0) {
                        c.s[i] += MOD;
                        a.s[i + 1]--;
                    }
                }
            }
        }
        while (c.s[c.s[0]] == 0 && c.s[0] > 1)
            c.s[0]--;
        return c;
    }
    BIGNUM operator+=(const BIGNUM &a) {
        *this = *this + a;
        return *this;
    }
    BIGNUM operator-(const BIGNUM &B) {
        BIGNUM c, a = *this, b = B;
        if ((!a.flag) && (!b.flag)) {
            if (a >= b) {
                c.flag = 0;
                c.s[0] = max(a.s[0], b.s[0]) + 1;
                for (int i = 1; i <= c.s[0]; i++) {
                    c.s[i] = a.s[i] - b.s[i];
                    if (c.s[i] < 0) {
                        c.s[i] += MOD;
                        a.s[i + 1]--;
                    }
                }
            } else {
                c.flag = 1;
                c.s[0] = max(a.s[0], b.s[0]) + 1;
                for (int i = 1; i <= c.s[0]; i++) {
                    c.s[i] = b.s[i] - a.s[i];
                    if (c.s[i] < 0) {
                        c.s[i] += MOD;
                        b.s[i + 1]--;
                    }
                }
            }
        } else {
            b.flag = !b.flag;
            c = a + b;
        }
        while (c.s[c.s[0]] == 0 && c.s[0] > 1)
            c.s[0]--;
        return c;
    }
    BIGNUM operator-=(const BIGNUM &a) {
        *this = *this - a;
        return *this;
    }
    BIGNUM operator*(const BIGNUM &B) {
        BIGNUM c, a = *this, b = B;
        c.init();
        if (!(a.flag || b.flag) || (a.flag && b.flag))
            c.flag = 0;
        else {
            if ((a.s[0] == 1 && a.s[1] == 0) || (b.s[0] == 1 && b.s[1] == 0))
                c = 0;
            else
                c.flag = 1;
        }
        c.s[0] = a.s[0] + b.s[0];
        for (int i = 1; i <= a.s[0]; i++) {
            int x = 0;
            for (int j = 1; j <= b.s[0]; j++) {
                c.s[i + j - 1] += a.s[i] * b.s[j] + x;
                x = c.s[i + j - 1] / MOD;
                c.s[i + j - 1] %= MOD;
            }
            c.s[i + b.s[0]] = x;
        }
        while (c.s[c.s[0]] > 0)
            c.s[0]++;
        while (c.s[c.s[0]] == 0 && c.s[0] > 1)
            c.s[0]--;
        return c;
    }
    BIGNUM operator*=(const BIGNUM &a) {
        *this = *this * a;
        return *this;
    }
    BIGNUM operator<<(const int &a) {
        for (int i = 0; i < a; i++) {
            s[0]++;
            for (int j = s[0]; j > 0; j--) {
                s[j] <<= 1;
            }
            for (int j = 1; j < s[0]; j++) {
                if (s[j] >= MOD) {
                    s[j] -= MOD;
                    s[j + 1]++;
                }
            }
            while (s[s[0]] == 0 && s[0] > 1)
                s[0]--;
        }
        return *this;
    }
    BIGNUM operator<<=(const int &a) {
        *this = *this << a;
        return *this;
    }
    BIGNUM operator>>(const int &a) {
        for (int i = 0; i < a; i++) {
            for (int j = s[0]; j > 0; j--) {
                if ((s[j] & 1) && j != 1)
                    s[j - 1] += MOD;
                s[j] >>= 1;
            }
        }
        while (s[s[0]] == 0 && s[0] > 1)
            s[0]--;
        return *this;
    }
    BIGNUM operator>>=(const int &a) {
        *this = *this >> a;
        return *this;
    }
    BIGNUM operator/(const BIGNUM &c) {
        BIGNUM a = *this, b = c, temp, ans;
        ans.init();
        temp.init();
        ans = 0;
        temp = 1;
        bool sign;
        if (!(a.flag || b.flag) || (a.flag && b.flag) || cmp_abs(c) == -1)
            sign = 0;
        else
            sign = 1;
        a.flag = b.flag = 0;
        while (a >= b) {
            b <<= 1;
            temp <<= 1;
        }
        while (temp.s[0] > 1 || temp.s[1]) {
            if (a >= b) {
                a -= b;
                ans += temp;
            }
            b >>= 1;
            temp >>= 1;
        }
        while (!ans.s[ans.s[0]] && ans.s[0] > 1)
            ans.s[0]--;
        ans.flag = sign;
        return ans;
    }
    BIGNUM operator/=(const BIGNUM &a) {
        *this = *this / a;
        return *this;
    }
    BIGNUM operator%(const BIGNUM &a) {
        BIGNUM c = *this / a, d = c * a;
        return *this - d;
    }
    BIGNUM operator%=(const BIGNUM &a) {
        *this = *this % a;
        return *this;
    }
};
ostream &operator<<(ostream &out, const BIGNUM &a) {
    if (a.flag) {
        out << '-';
    }
    out << a.s[a.s[0]];
    for (int i = a.s[0] - 1; i >= 1; i--)
        out << fixed << setfill('0') << setw(9) << a.s[i];
    return out;
}
istream &operator>>(istream &in, BIGNUM &a) {
    char str[LEN];
    in >> str;
    a = str;
    return in;
}
```
== 二进制

=== 二进制枚举子集

```cpp
for (int i = n; i; i = (i - 1) & n)//枚举n的子集
```