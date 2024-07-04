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
  title:"计算几何",
  depth: 4,//设置显示几级目录
  fill: line(length: 100%)
)
= 前置知识

== 判段正负

```cpp
//在-eps-eps之间都视为相等
int sign(db a) { return a < -eps ? -1 : a > eps; }
```
== 弧度角度转换

```cpp
const db pi = acos(-1);
db RD(db r) {
    return 180 / pi * r;
}
db DR(db D) {
    return pi / 180 * d;
}
```

== 计算弧长

$ L=n^degree times r times pi/(180^degree) $

$ L = alpha times r $

n是圆心角(角度制),r是半径,L是圆心角弧长,$alpha$是圆心角度数(弧度制)

== 向量旋转

点/向量顺时针旋转$theta^degree$
$
mat(
    x , y;  
) 
mat(
    cos theta, -sin theta;
    sin theta, cos theta;  
) 
=
mat(
    x cos theta+y sin theta\, -x sin theta +y cos theta ;  
) $
点/向量逆时针旋转$theta^degree$
$
mat(
    cos theta, -sin theta;
    sin theta, cos theta;  
)
mat(
    x ; y;  
)  
=
mat(
    x cos theta - y sin theta;
    x sin theta + y cos theta ;  
) $
```cpp
Point rotate(db angele) { // 向量逆时针旋转
        return Point(x * cos(angele) - y * sin(angele), x * sin(angele) + y * cos(angele));
}
```
== 浮点数

+0.0,-0.0

INFINITY: 无穷

NaN:非数(NaN opt oth=NaN)


```cpp
cout << 1.0 / 0.0 << endl;  // inf
cout << 1.0 / -0.0 << endl; //-inf
cout << 0.0 / 0.0 << endl;  // nan
cout << INFINITY << endl;   // inf
```

nan与任意浮点数的比较,包括nan,正负无穷

#table(
  columns: (1fr, 1fr,1fr,1fr,1fr,1fr),
  rows: (30pt, 30pt),
  align: center,
  inset: 10pt,
  [$\N\a\N>= x$],[$\N\a\N<= x$],[$\N\a\N> x$],[$\N\a\N<x$],[$\N\a\N= x$],[$\N\a\N!= x$],[False],[False],[False],[False],[False],[True],
)

触发NaN的情况:
#figure(
    image("/pic/generate NaN.png",width:100%),
    caption: [Nan的触发情况],
) <glaciers>

== Tips

1.能整数就不要浮点数(手写分数)

2.double/long double ,no float

3.少用数学函数(sqrt,sin,cos)

4.eps
= 二维计算几何

== 点

=== 模板
```cpp
struct Point {
    db x, y;
    Point() {}
    Point(db x, db y) : x(x), y(y) {}
    Point operator+(Point p) { return {x + p.x, y + p.y}; }
    Point operator-(Point p) { return {x - p.x, y - p.y}; }
    Point operator*(db d) { return {x * d, y * d}; }
    Point operator/(db d) { return {x / d, y / d}; }
    bool operator==(Point &p) const { return !sign(x - p.x) && !sign(y - p.y); }
    db dot(Point T) {
        return x * T.x + y * T.y;
    }
    db cross(Point T) {
        return x * T.y - y * T.x;
    }
    db len() {
        return sqrt(this->dot(*this));
    } 
    ll dis(Point T) {//两点距离
        return (x - T.x) * (x - T.x) + (y - T.y) * (y - T.y);
    }
    bool ver(Point b) {//是否垂直
        return x * b.x + y * b.y == 0;
    }
    int toleft(Point b) {//点在线段的方向
        ll res = x * b.y - y * b.x;
        if (res == 0)
            return 0; // 直线上
        else if (res > 0)
            return 1; // 左
        return -1;    // 右
    }
    friend istream &operator>>(istream &is, Point &p) {
        return is >> p.x >> p.y;
    }
    friend ostream &operator<<(ostream &os, Point p) {
        return os << "(" << p.x << ", " << p.y << ")";
    }
};
```
=== 点绕点旋转

逆时针
```cpp
Point rotate(Point p, db angele) {
    Point v = (*this) - p;
    db c = cos(angele), s = sin(angele);
    return Point(p.x + v.x * c - v.y * s, p.y + v.x * s + v.y * c);
}
```
顺时针

与向量的旋转类似

$ mat(
   (x-x_0) cos theta+(y-y_0) sin theta\+x_0, -(x-x_0) sin theta +(y-y_0) cos theta+y_0 ;  
) $
```cpp
Point rotate(Point p, db angele) { // 绕点顺时针旋转
        db x = (x - p.x) * cos(angele) + (y - p.y) * sin(angele) + p.x;
        db y = -(x - p.x) * sin(angele) + (y - p.y) * cos(angele) + p.y;
        return Point(x, y);
    }
```
== 向量

=== 点积(Dot product)

$arrow(a)dot arrow(b)=a_x b_x+a_y b_y$

```cpp
ll dot(Point a, Point b) {
    return a.x * b.x + a.y * b.y;
}
```
几何意义:

$arrow(a)dot arrow(b)=||a||||b||cos theta$

a在b方向上投影/b在a方向上投影与b/a的乘积

1. dot (a,b)$>0$, $0 <= theta <pi/2$

2. dot (a,b)$=0$, $ theta =pi/2$

3. dot (a,b)$<0$, $pi/2 < theta <=pi$
==== 应用

===== 向量长度
$||arrow(a)||=sqrt(arrow(a) dot arrow(a))$

```cpp
db len(Point a) { return sqrt(a.dot(a)); }
```
===== 向量夹角
$cos theta =(arrow(a) dot arrow(b))/(||arrow(a)|| ||arrow(b)||)$
```cpp
db angle(Point a, Point b) {
    return acos(a.dot(b) / len(a) / len(b));
}
```

向量在另一向量的投影:$||arrow(a)|| cos theta =(arrow(a) dot arrow(b))/(||arrow(b)||)$

向量垂直:$arrow(a) dot arrow(b)=0$

=== 叉积(Cross product)

#figure(
    image("/pic/cross.png",width:50%),
    caption: [叉积],
) <glaciers>

$arrow(a) times arrow(b)=a_x b_y-a_y b_x $

几何意义:

$arrow(a) times arrow(b)=||arrow(a)|| ||arrow(b)|| sin theta$

其运算结果是一个向量，并且与这两个向量都垂直，是这两个向量所在平面的法线向量

```cpp
ll cross(Point a, Point b) {
    return a.x * b.y - a.y * b.x;
}
```
==== 应用

===== 平面四边形面积

$|arrow(a) times arrow(b)|$

===== 向量平行

$arrow(a) times arrow(b)=0$

===== to-left测试

右手定则,四指从a转到b

判段点p在直线AB的左/右侧上

1. $arrow(a) times arrow(b)>0$ 左侧

2. $arrow(a) times arrow(b)<0$ 右侧

3. $arrow(a) times arrow(b)=0$ 在直线上(同向/异向)

```cpp
int toLeft(Point p, Point a, Point b) { return sign(cross(b - a, p - a)); }
```
== 线段

=== 判段点是否在线段上

p在直线AB上:

$ arrow("PB") times arrow("PB")=arrow(0) $

p在线段AB之间:

$ arrow("PB") dot arrow("PB")<=0 $

或

$ cases(
    min{A_x,B_x}<= P_x <=max{A_x,B_x},
    min{A_y,B_y}<= P_y <=max{A_y,B_y}
) $
```cpp
// 如果不包括端点,就把<=改成<
bool onseg(Point p, Point a1, Point a2) {
    return cross(a1 - p, a2 - p) == 0 && dot(a1 - p, a2 - p) <= 0;
}
```
=== 判段两线段AB,CD是否相交

1.快速排斥实验

如果横纵坐标不相交,显然线段也不相交

2.跨立实验

A,B 在CD两侧 AND C,D 在AB两侧

特判三点共线,四点共线的情况

```cpp
// 叉积有可能爆ll,要使用int128
bool spi(Point a1, Point a2, Point b1, Point b2) {
    //快速排斥实验
    if (max(a1.x, a2.x) < min(b1.x, b2.x) || max(b1.x, b2.x) < min(a1.x, a2.x) || max(a1.y, a2.y) < min(b1.y, b2.y) || max(b1.y, b2.y) < min(a1.y, a2.y))
        return 0;
    // 跨立实验
    ll c1 = cross(a2 - a1, b1 - a1);
    ll c2 = cross(a2 - a1, b2 - a1);
    ll c3 = cross(b2 - b1, a1 - b1);
    ll c4 = cross(b2 - b1, a2 - b1);
    // 如果端点相交不算相交,就把小于等于改成小于
    return c1 * c2 <= 0 && c3 * c4 <= 0;
}
```
== 直线

表达式:点向式(直线上一点,方向向量)

=== 求点到直线距离

已知点向式直线$(P,arrow(v))$,求A到直线距离

设交点为B

$abs(arrow("AB"))=abs(arrow("PA"))abs(sin theta)=abs(arrow(v) times arrow("PA"))/(abs(arrow(v)))$
```cpp
db dis_p_to_l(Point p, Point &a, Point &v) {
    Point pa = p - a;
    return fabs(cross(v, pa)) / v.len();
}
```

=== 求点在直线的投影点

#figure(
    image("/pic/点在直线投影点.png",width:70%),
    caption: [点在直线的投影点],
) <glaciers>

$abs(arrow("AB"))=abs(arrow("AP")) cos theta =(arrow("AP") dot arrow(v))/abs(arrow(v))$

$arrow("OB")=arrow("OA")+arrow("AB")=arrow("OA")+abs(arrow("AP"))/abs(arrow("v"))arrow("v")$

$=arrow("OA")+(arrow("AP") dot arrow(v))/(abs(arrow(v))abs(arrow(v)))arrow(v)=arrow("OP")+(arrow("AP") dot arrow(v))/(arrow(v)^2)arrow(v)$

```cpp
Point p_on_l(Point p, Point a, Point v) {
    Point pa = p - a;
    return a + v * (dot(pa, v) / dot(v, v));
}
```
=== 求两直线交点

#figure(
    image("/pic/两直线交点.png",width:70%),
    caption: [两直线交点],
) <glaciers>

设交点为Q

根据正弦定理$a/(sin A)=b/(cos B)=c/(cos C)=2R$ (R是外接圆半径)

$ cases(
    abs(arrow(P_1Q))/(sin alpha)=abs(arrow(P_1P_2))/(sin beta),
    abs(arrow(v_2)times arrow(P_2P_1))=abs(arrow(v_2))abs(arrow(P_2P_1))sin alpha,
    abs(arrow(v_1)times arrow(v_2))=abs(arrow(v_1))abs(arrow(v_2))sin beta
) $
$sin alpha ,sin beta,abs(arrow(P_1P_2))$都是已知的

$abs(arrow(P_1Q))=(abs(arrow(v_2)times arrow(P_2P_1))abs(arrow(v_1)))/abs(arrow(v_1)arrow(v_2))arrow(v_1)$

$arrow("OQ")=arrow("OP"_1)+arrow("P"_1"Q")$

```cpp
Point l_intersect(Point a, Point v, Point b, Point w) {
    Point u = a - b;
    ll t = cross(w, u) / cross(v, w);
    return a + v * t;
}
```
== 多边形

=== 多边形面积

分解成若干个三角形

$S=1/2 abs(sum_(i=0)^(n-1) arrow("OP"_i)times arrow("OP"_(i+1)))$

O无论选在多边形内还是多边形外都是成立的

```cpp
db convex_polygon_area(vector<Point> &a) {
    db res = 0;
    for (int i = 0; i < a.size(); i++)
        res += cross(a[i], a[(i + 1) % a.size()]);
    return fabs(res) / 2;
}
```
如果是按顺时针给出的多边形,计算出来的有向面积会是负值

```cpp
bool isclockwise(vector<Point> &p) {
    return convex_polygon_area(p) < 0;
}
```
=== 判段点是否在多边形内部

1.光线投射

2.回转数(Winding number)

回转数为0,点在多边形外
```cpp
//在多边形边上(包括端点)返回1e9
//在多边形外返回0
//其他情况在多边形内
int c_p_i_p(Point p, vector<Point> &poly) {
    int wn = 0, n = poly.size();
    for (int i = 0; i < n; i++) {
        if (onseg(p, poly[i], poly[(i + 1) % n]))
            return 1e9;
        ll k = cross(poly[(i + 1) % n] - poly[i], p - poly[i]);
        ll d1 = poly[i].y - p.y;
        ll d2 = poly[(i + 1) % n].y - p.y;
        if (k > 0 && d1 <= 0 && d2 > 0)
            wn++;
        if (k < 0 && d2 <= 0 && d1 > 0)
            wn--;
    }
    return wn;
}
```
3.n次to-left测试(仅限于凸多边形)

假如不确定是否是凸多边形(退化成点,线,顺时针顺序)

需要先判断是否在某条边上,再判段是否是不相交的共线,然后判段三次toleft是否正负性一致

https://ac.nowcoder.com/acm/contest/27249/G

给定三个点,判断询问的点是否在形成的三角形(如果有)内
```cpp
ll sign(ll a) { return a < 0 ? -1 : a > 0; }
struct Point {
    ll x, y;
    Point() {}
    Point(ll _x, ll _y) : x(_x), y(_y) {}
    Point operator+(Point p) { return {x + p.x, y + p.y}; }
    Point operator-(Point p) { return {x - p.x, y - p.y}; }
    Point operator*(ll d) { return {x * d, y * d}; }
    friend istream &operator>>(istream &is, Point &p) {
        return is >> p.x >> p.y;
    }
    friend ostream &operator<<(ostream &os, Point p) {
        return os << "(" << p.x << ", " << p.y << ")";
    }
};
ll dot(Point a, Point b) {
    return a.x * b.x + a.y * b.y;
}
ll cross(Point a, Point b) {
    return a.x * b.y - a.y * b.x;
}

int toLeft(Point p, Point a, Point b) { return sign(cross(b - a, p - a)); }

bool onseg(Point p, Point a1, Point a2) {
    return cross(a1 - p, a2 - p) == 0 && dot(a1 - p, a2 - p) <= 0;
}
void solve() {

    Point a, b, c;
    cin >> a >> b >> c;
    int n;
    cin >> n;
    for (int i = 1; i <= n; i++) {
        Point t;
        cin >> t.x >> t.y;
        if (onseg(t, a, b) || onseg(t, b, c) || onseg(t, c, a)) {
            cout << "YES" << endl;
            continue;
        }
        if (toLeft(t, a, c) != 0 && toLeft(t, b, a) == toLeft(t, c, b) && toLeft(t, c, b) == toLeft(t, a, c)) {
            cout << "YES" << endl;
            continue;
        }
        cout << "NO" << endl;
    }
}
```
== 极角序

=== 基础知识

极点(Ploe)

极轴(Polar axis)

极径(Radius)

极角(Polar angle/Argument) 

$(-pi,pi]$

$[0,2pi)$

极坐标(Polar coordinate)

直角坐标与极坐标的转换

$tan phi=y/x$

=== 极角排序

1.半平面($<180^degree$)

to left测试

2.全平面

直接计算极角

atan2(y,x)

atan2l(y,x)(long double 版本)

范围:$(-pi,pi)$

atan($y/x$)

一般不用,避免除0错误
== 圆

=== 圆与直线交点

==== 交点个数
先求圆心到直线距离,然后再比较距离与半径的大小关系
```cpp
int get_c_to_l(Circle o, Point &p, Point &v) {
    db dist = dis_p_to_l(o.p, p, v);
    if (sign(dist - o.r) == 0)
        return 1;
    else if (sign(dist - o.r) < 0)
        return 2;
    return 0;
}
```
==== 交点位置

先判断有交点,再求
```cpp
vector<Point> &get_c_to_l(Circle o, Point &p, Point &v) {
    db dist = dis_p_to_l(o.p, p, v);      // 圆心到直线距离
    db d = sqrt(o.r * o.r - dist * dist); // 半弦长
    Point v1 = v.rotate(3 * pi / 2);      // 方向向量
    Point mid = o.p + v1 * dist;          // 中点
    vector<Point> ans;
    if (sign(dist - r) == 0) // 相切
        ans.push_back(mid);
    else {
        ans.push_back(mid + v * d);
        ans.push_back(mid - v * d);
    }
    return ans;
}
```