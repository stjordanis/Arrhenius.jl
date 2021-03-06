"get specific of heat capacity"
function get_cp(gas, T, X, mean_MW)
    if T <= 1000.0
        cp = @view(gas.thermo.nasa_low[:, 1:5]) * [1.0, T, T^2, T^3, T^4]
    else
        cp = @view(gas.thermo.nasa_high[:, 1:5]) * [1.0, T, T^2, T^3, T^4]
    end
    cp_mole = dot(cp, X) * R
    cp_mass = cp_mole / mean_MW
    return cp_mole, cp_mass
end
export get_cp

"get enthaphy (H) per mole"
function get_H(gas, T, Y, X)
    H_T = [1.0, T / 2.0, T^2 / 3.0, T^3 / 4.0, T^4 / 5.0, 1.0 / T]
    if T <= 1000.0
        h_mole = @view(gas.thermo.nasa_low[:, 1:6]) * H_T * R * T
    else
        h_mole = @view(gas.thermo.nasa_high[:, 1:6]) * H_T * R * T
    end
    # H_mole = dot(h_mole, X)
    return h_mole
end
export get_H

function H_mass_func(gas, h_mole, Y)
    return dot(h_mole ./ gas.MW, Y)
end
export H_mass_func

"get entropy (S)"
function get_S(gas, T, P, X)
    S_T = [log(T), T, T^2 / 2.0, T^3 / 3.0, T^4 / 4.0, 1.0]
    if T <= 1000.0
        S0 = @view(gas.thermo.nasa_low[:, [1, 2, 3, 4, 5, 7]]) * S_T * R
    else
        S0 = @view(gas.thermo.nasa_high[:, [1, 2, 3, 4, 5, 7]]) * S_T * R
    end
    # _X = @. S0 - R * log(clamp(X, 1.e-30, Inf))
    # s_mole = _X .- R * (P / one_atm)
    # S_mole = dot(s_mole, X)
    return S0
end
export get_S

function S_mass_func(gas, s_mole, Y)
    return dot(s_mole ./ gas.MW, Y)
end
export S_mass_func
