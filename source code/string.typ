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
  title:"字符串",
  depth: 4,//设置显示几级目录
  fill: line(length: 100%)
)

= 基础定义

== 子串,前缀(prefixs),后缀(suffixs)


== 周期
存在一个$p$,使得$p <i<=|S|$,满足$S[i]=S[i-p]$,则称p是S的一个周期

=== 周期定理

如果$p,q$均是$s$的周期,则$gcd(p,q)$也是s的周期
== 循环节
若周期$p bar.v |S|$,则周期p是S的一个循环节
== Border

存在一个长度len,满足该长度的前缀和后缀相同,则称该前缀/后缀是该字符串的一个border



=== 特殊性质

1. p是S的周期$\u{21D4}$|S|-p是S的Border

证明:

p是S的周期$\u{21D4}$S[i-p]=S[i]


p是S的Border$\u{21D4}$S[1,q]=S[|S|-q+1,|S|]

$S[1]=S[ |S|-q+1]$


$S[2]=S[ |S|-q+2]$

2. Border的传递性

S的Border的Border的也是S的Border

3. 一个串的Border数量是$O(N)$个,但是他们组成了$O(log N)$个等差数列


= 哈希


== 单哈希

```cpp
struct Hash
{
    const ll base = 1361;
    const ll p = 998244353;
    int n;
    vector<ll> a, c;
    Hash(int _n, string arr) : n(_n), a(n + 10), c(n + 10, 0)
    {
        ll res = 0;
        c[0] = 1;
        for (int i = 1; i <= n; i++)
        {
            res = (res * base + arr[i]) % p;
            c[i] = c[i - 1] * base % p;
            a[i] = res;
        }
    }
    ll query(int l, int r) // 询问子串的哈希值
    {
        // if (l < 1 || r > n)
        //     cout << "invalid input" << endl;
        ll ans = (a[r] - a[l - 1] * c[r - l + 1] % p + p) % p;
        return ans;
    }
};
```

== 双哈希

```cpp
struct Hash
{
    const ll base1 = 1361, base2 = 1301;
    const ll p1 = 1000000123, p2 = 1000000021;
    int n;
    vector<ll> a1, a2, c1, c2;
    Hash(int _n) : n(_n), a1(n + 10), a2(n + 10), c1(n + 10, 0), c2(n + 10) {}
    void build(int n, vector<char> arr)
    {
        ll res = 0;
        c1[0] = 1, c2[0] = 1;
        for (int i = 1; i <= n; i++)
        {
            res = (res * base1 + arr[i]) % p1;
            c1[i] = c1[i - 1] * base1 % p1;
            a1[i] = res;
        }
        res = 0;
        for (int i = 1; i <= n; i++)
        {
            res = (res * base2 + arr[i]) % p2;
            c2[i] = c2[i - 1] * base2 % p2;
            a2[i] = res;
        }
    }
    pll query(int l, int r) // 询问子串的哈希值
    {
        ll hashval1 = (a1[r] - 1ll * a1[l - 1] * c1[r - l + 1] % p1 + p1) % p1;
        ll hashval2 = (a2[r] - 1ll * a2[l - 1] * c2[r - l + 1] % p2 + p2) % p2;
        return {hashval1, hashval2};
    }
};
```
== 带修哈希
用树状数组维护即可

```cpp

```
== 树哈希

= KMP

== 原理

前缀i的border的长度-1$arrow$前缀i-1的border的长度

kmp实际就是在暴力这个逆过程,枚举右边,看看是否满足

next数组:

next[i]=Preffix[i]的非平凡的最大Border(非平凡:除掉自己)
== kmp求border

```cpp
vector<int> nxt(N, 0);
void kmp(vector<char> &s, int n)
{
    nxt[1] = 0;
    for (int i = 2; i <= n; i++)
    {
        nxt[i] = nxt[i - 1];
        while (nxt[i] && s[i] != s[nxt[i] + 1])
            nxt[i] = nxt[nxt[i]];
        nxt[i] += (s[i] == s[nxt[i] + 1]);
    }
}
```
== kmp匹配

```cpp
struct KMP {
    vector<char> t;
    vector<int> nxt, ans;
    int n;
    KMP(int n, string &s1) : n(n), t(n + 10), nxt(n + 10) { // 求border
        for (int i = 1; i <= n; i++)
            t[i] = s1[i];
        nxt[1] = 0;
        for (int i = 2; i <= n; i++) {
            nxt[i] = nxt[i - 1];
            while (nxt[i] && t[i] != t[nxt[i] + 1])
                nxt[i] = nxt[nxt[i]];
            nxt[i] += (t[i] == t[nxt[i] + 1]);
        }
    }
    ll find(int m, string &s) { // kmp匹配
        ll p = 0, res = 0;
        for (int i = 1; i <= m; i++) {
            while (p == n || (p && t[p + 1] != s[i]))
                p = nxt[p];
            p += (t[p + 1] == s[i]);
            if (p == n)
                res++;
        }
        return res;
    }
};
```
= Border树

== 定义
对于一个长度为n的字符串,它的border树有n+1个节点

0是树的根,对于其他节点,父节点为nxt$[i]$

== 性质

1.字符串的某个前缀i的border就是border树中i到根的链

2.求哪些前缀有长度为x的border:x的子树

3.求两个前缀的公共border:border树的lca
```cpp
```
= Manacher


```cpp
struct Manacher
{
    // 设插入$后的字符串为s',那么s'与原串s存在以下关系:
    // s'的极长回文子串一定为奇数(因为一定以$结尾)
    //|s'|=2|s|+1
    //|s|=(|s'|-1)/2
    //|s|=|s'|/2(下取整)
    int m;
    vector<char> a;
    vector<int> p; // p[i]表示以i为中心的最长回文子串
    Manacher(int _n) : a(2 * _n + 10), p(2 * _n + 10) {}
    void build(int n, vector<char> &s)
    {
        m = 0;
        a[++m] = '$';
        for (int i = 1; i <= n; i++)
            a[++m] = s[i], a[++m] = '$';
        int M = 0, R = 0;
        for (int i = 1; i <= m; i++)
        {
            if (i > R)
                p[i] = 1;
            else
                p[i] = min(p[2 * M - i], R - i + 1);
            while (i - p[i] > 0 && i + p[i] - 1 <= m && a[i - p[i]] == a[i + p[i]]) // 暴力向右拓展
                ++p[i];
            if (i + p[i] - 1 > R) // 更新右端点最右的回文串的回文中心,回文半径
                M = i, R = i + p[i] - 1;
        }
    }
    int query()
    {
        int ans = 0;
        for (int i = 1; i <= m; i++)
            ans = max(ans, p[i] - 1);
        return ans;
    }
};
```