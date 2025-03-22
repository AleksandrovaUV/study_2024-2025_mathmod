---
## Front matter
title: "Лабораторная работа №3"
subtitle: "Математическое моделирование"
author: "Александрова Ульяна Вадимовна"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: IBM Plex Serif
romanfont: IBM Plex Serif
sansfont: IBM Plex Sans
monofont: IBM Plex Mono
mathfont: STIX Two Math
mainfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
romanfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
sansfontoptions: Ligatures=Common,Ligatures=TeX,Scale=MatchLowercase,Scale=0.94
monofontoptions: Scale=MatchLowercase,Scale=0.94,FakeStretch=0.9
mathfontoptions:
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Целью работы является построение модели боевых действий на языке Julia.

# Задание

ВАРИАНТ 35

Между страной $X$ и страной $Y$ идет война. Численность состава войск исчисляется от начала войны, и являются временными функциями $x(t)$ и $y(t)$. В начальный момент времени страна $X$ имеет армию численностью 31 050  человек, а в распоряжении страны $Y$ армия численностью в 20 002 человек. Для упрощения модели считаем, что коэффициенты $a, b, c, h$ постоянны. Также считаем $P(t)$ и $Q(t)$ непрерывные функции.

Построить графики изменения численности войск армии $X$ и армии $Y$ для  следующих случаев:


1. Модель боевых действий между регулярными войсками

$$\begin{cases}
    \dfrac{dx}{dt} = -0.25x(t)- 0.74y(t)+sin(t+5)\\
    \dfrac{dy}{dt} = -0.64x(t)- 0.55y(t)+cos(t+6)
\end{cases}$$

2. Модель ведение боевых действий с участием регулярных войск и партизанских отрядов

$$\begin{cases}
    \dfrac{dx}{dt} = -0.32x(t)-0.89y(t)+2*sin(10t)\\
    \dfrac{dy}{dt} = -0.51x(t)y(t)-0.62y(t)+2*cos(10t)
\end{cases}$$

# Теоретическое введение

В противоборстве могут принимать участие как регулярные войска, так и партизанские отряды. В общем случае главной характеристикой соперников являются численности сторон. Если в какой-то момент времени одна из численностей обращается в нуль, то данная сторона считается проигравшей (при условии, что численность другой стороны в данный момент положительна). 

# Выполнение лабораторной работы

Зададим коэффициент смертности, не связанный с боевыми действиями у первой армии 0,25, у второй 0,55. Коэффициенты эффективности первой и второй армии 0,64 и 0,74 соответственно. Функция, описывающая подход подкрепление первой армии, $P(t)=sint+1$, подкрепление второй армии описывается функцией $Q(t)=cost+1$. 

Построим графики через утилиту Julia.

```julia
using Plots
using DifferentialEquations

# constanty 
xy = [31050, 20002]
abch = [0.25, 0.74, 0.64, 0.55]
tspan = (0,1)

# kater

function between_common(xy, abch, t)
    x, y = xy 
    a, b, c, h = abch
    dx = -a*x - b*y + sin(t+5)
    dy = -c*x - h*y + cos(t + 6)
    
    return [dx, dy]
end

odu = ODEProblem(between_common, xy, tspan, abch)

result = solve(odu, Tsit5())

plot(result, title = "Модель боевых действий", label = ["Army X" "Army Y"], dpi = 300)
```

Результат представлен на графике (рис. [-@fig:001]).

![Модель боевых действий  между регулярными войсками](image/1.png){#fig:001 width=70%}

Мы видим, что на графике побеждает армия Х, так как численность армии Y быстрее достигла нуля. Однако уменьшение численности армии происходит равномерно.

Во втором случае в борьбу добавляются партизанские отряды. Нерегулярные войска в отличии от постоянной армии менее уязвимы, так как действуют скрытно, в этом случае сопернику приходится действовать неизбирательно, по площадям, занимаемым партизанами. Поэтому считается, что тем потерь партизан, проводящих свои операции в разных местах на некоторой известной территории, пропорционален не только численности армейских соединений, но и численности самих партизан.

Построим модель на Julia:

```julia
# constanty 
xy = [31050, 20002]
abch = [0.32, 0.89, 0.51, 0.62]
tspan = (0,0.001)

# kater

function between_common_part(xy, abch, t)
    x, y = xy 
    a, b, c, h = abch
    dx = -a*x - b*y + 2*sin(10*t)
    dy = -c*x*y - h*y + 2*cos(10*t)
    
    return [dx, dy]
end

odu = ODEProblem(between_common_part, xy, tspan, abch)

result = solve(odu, Tsit5())

plot(result, title = "Модель боевых действий", label = ["Army X" "Army Y"], dpi = 300)
```

Результат представлен на графике (рис. [-@fig:002]).

![Модель ведение боевых действий с участием регулярных войск и партизанских отрядов](image/2.png){#fig:002 width=70%}

По графику видно, что  уменьшение численность армии Y происходит мгновенно, вероятно из-за возникновения дополнительныз отрядов. При этом численность Армии X не почти не меняется со временем, так как она победила.

# Выводы

У меня получилось построить модель боевых действий в утилите Julia.
