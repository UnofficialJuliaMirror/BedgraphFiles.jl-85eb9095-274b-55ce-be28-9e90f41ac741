@testset "GenomicFeatures" begin

    using GenomicFeatures


    # Test conversions.
    @test GenomicFeatures.GenomicInterval("chr1", 1, 1) == convert(GenomicFeatures.GenomicInterval{Nothing}, Bag.record)
    @test GenomicFeatures.GenomicInterval("chr1", 1, 1, '?', 0.0) == convert(GenomicFeatures.GenomicInterval{Float64}, Bag.record)
    @test GenomicFeatures.GenomicInterval("chr1", 1, 1, '?', 0) == convert(GenomicFeatures.GenomicInterval{Int64}, Bag.record)


    # Test conversion to Vector{GenomicInterval{Nothing}}
    @test convert(Vector{GenomicFeatures.GenomicInterval{Nothing}}, Bag.records) == convert(Vector{GenomicFeatures.GenomicInterval{Nothing}}, load(Bag.file))
    @test convert(Vector{GenomicFeatures.GenomicInterval{Float64}}, Bag.records) == convert(Vector{GenomicFeatures.GenomicInterval{Float64}}, load(Bag.file))
    col = convert(GenomicFeatures.GenomicIntervalCollection{Nothing}, Bag.records)

    @test  GenomicFeatures.GenomicIntervalCollection{Nothing}(Bag.records) == convert(GenomicFeatures.GenomicIntervalCollection{Nothing}, Bag.records)

    @test col == GenomicFeatures.GenomicIntervalCollection{Nothing}(load(Bag.file))
    @test col == GenomicFeatures.GenomicIntervalCollection{Nothing}(load(Bag.file_headerless))

    @test col == load(Bag.file) |> GenomicFeatures.GenomicIntervalCollection{Nothing}
    @test col == load(Bag.file_headerless) |> GenomicFeatures.GenomicIntervalCollection{Nothing}


    # Test conversion to GenomicIntervalCollection{Float64}.
    col = convert(GenomicFeatures.GenomicIntervalCollection{Float64}, Bag.records)

    @test  GenomicFeatures.GenomicIntervalCollection{Float64}(Bag.records) == convert(GenomicFeatures.GenomicIntervalCollection{Float64}, Bag.records)

    @test col == GenomicFeatures.GenomicIntervalCollection{Float64}(load(Bag.file))
    @test col == GenomicFeatures.GenomicIntervalCollection{Float64}(load(Bag.file_headerless))

    @test col == load(Bag.file) |> GenomicFeatures.GenomicIntervalCollection{Float64}
    @test col == load(Bag.file_headerless) |> GenomicFeatures.GenomicIntervalCollection{Float64}

    # Test converstion to Vector{Bedgraph.Record} from GenomicIntervalCollection
    @test Bag.records == convert(Vector{Bedgraph.Record}, col)
    @test Bag.records == Vector{Bedgraph.Record}(col)


    # Test saving GenomicIntervalCollection{Float64}.
    save(Bag.tmp_output_path, col) #Note: uses col from previous conversion to GenomicIntervalCollection{Float64} tests.

    @test Bag.records == Vector{Bedgraph.Record}(load(Bag.tmp_output_path))
    @test Bag.records == load(Bag.tmp_output_path) |> Vector{Bedgraph.Record}

    col |> save(Bag.tmp_output_path) #Note: uses col from previous conversion to GenomicIntervalCollection{Float64} tests.

    @test Bag.records == Vector{Bedgraph.Record}(load(Bag.tmp_output_path))
    @test Bag.records == load(Bag.tmp_output_path) |> Vector{Bedgraph.Record}


    # Test saving GenomicIntervalCollection{Nothing}.
    col2 = GenomicIntervalCollection([GenomicInterval("chr1", i, i + 99) for i in 1:100:10000])
    @test GenomicIntervalCollection{GenomicInterval{Nothing}} == typeof(col2)

    save(Bag.tmp_output_path, col2)
    @test col2 == GenomicIntervalCollection{Nothing}(load(Bag.tmp_output_path))
    @test col2 == load(Bag.tmp_output_path) |> GenomicIntervalCollection{Nothing}

end #testset GenomicFeatures
