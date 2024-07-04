#import "@preview/sourcerer:0.2.1": code
#code(
  lang: "c++",
```cpp
ll qmi(__int128_t a, ll b, ll p)
{
    ll res = 1;
    while (b)
    {
        if (b & 1)
            res = res * a % p;
        a = a * a % p;
        b >>= 1;
    }
    return res;
}
bool MR(ll n)
{
    if (n == 2)
        return true;
    if (n <= 1 || n % 2 == 0)
        return false;
    const ll base[7] = {2, 325, 9375, 28178, 450775, 9780504, 1795265022};
    ll u = n - 1, k = 0;
    while (u % 2 == 0)
        k++, u /= 2;
    for (auto &x : base)
    {
        if (x % n == 0)
            continue;
        ll v = qmi(x, u, n);
        if (v == 1 || v == n - 1)
            continue;
        for (int j = 1; j <= k; j++)
        {
            ll lst = v;
            v = (__int128_t)v * v % n;
            if (v == 1)
            {
                if (lst != n - 1)
                    return false;
                break;
            }
        }
        if (v != 1)
            return false;
    }
    return true;
}
```
)
