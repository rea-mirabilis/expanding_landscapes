using Random
using Random123
using Distributions
using Plots
using StatsPlots
using StatsBase
using Statistics
using DataFrames
using Chain
using Dates

include("Utils.jl")

mkpath("outputs/data")
mkpath("outputs/figures")

total_population = 1000
σ_epi::Float64 = 0.1

μ = (1 / total_population) / 10
M = μ/10

simulation_length = 50000
loci = 100
init_active_loci = 10
max_init_genotype_bits = 1

rng_default, rng_additive, rng_init_genotype, rng_init_genome, rng_mutation =
    initialize_prngs(genome_seed = 123, mutation_seed = 123)

additive_effects = generate_additive_effects(rng_additive, 0.1, 128)

df_genotypes = simulate(
    loci,
    init_active_loci,
    max_init_genotype_bits,
    total_population,
    σ_epi,
    μ,
    M,
    simulation_length,
    rng_init_genome,
    rng_init_genotype,
    rng_default,
    rng_mutation,
    additive_effects
)


println("Simulation finished.")
println("Rows in df_genotypes: ", nrow(df_genotypes))
println("Maximum generation: ", maximum(df_genotypes.Step))
println()
println(first(df_genotypes, 10))

df_counts,
df_full_steps,
df_genome_counts,
df_per_genome_genotypes,
df_avg_fitness,
df_genome_size,
sweeps = process_data(df_genotypes, μ, M, additive_effects, σ_epi)

println()
println("Average fitness:")
println(first(df_avg_fitness, 10))

println()
println("Sweeps:")
println(sweeps)

generate_plots(df_genotypes, μ, M, additive_effects, σ_epi, save = true)