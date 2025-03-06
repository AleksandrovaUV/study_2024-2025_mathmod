using Plots
using DifferentialEquations

# constanty 
const k = 9.8
const v = 3.8
const r0 = k / 4.8
const r0_2 = k / 2.8
const t = (0.0, 2*pi)
const t2 = (-pi, pi)

# kater

function kater(r, p, t)
	return r / sqrt(v*v - 1)
end

odu = ODEProblem(kater, r0, t)

result = solve(odu, abstol=1e-8, reltol=1e-8)
random = rand(1:size(result.t)[1])
ran_angles = [result.t[random] for i in 1:size(result.t)[1]]

plt = plot(proj=:polar, aspect_ratio=:equal, dpi = 1000, legend=true)

plot!(plt, xlabel="t", ylabel="r(t)", title="Задача о погоне", legend=:outerbottom)
plot!(plt, [ran_angles[1], ran_angles[2]], [0.0, result.u[size(result.u)[1]]], label="Движение лодки", color=:green, lw=1)
scatter!(plt, ran_angles, result.u, label="", mc=:green, ms=0.0005)
plot!(plt, result.t, result.u, xlabel="t", ylabel="r(t)", label="Движение катера", color=:black, lw=1)
scatter!(plt, result.t, result.u, label="", mc=:black, ms=0.0005)

savefig(plt, "math_m_lab2_01.png")