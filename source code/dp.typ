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
  title:"Dp",
  depth: 4,//设置显示几级目录
  fill: line(length: 100%)
)