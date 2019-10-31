@debug "BedgraphFiles loading GenomicFeatures integration."

using .GenomicFeatures

function Base.convert(::Type{Bedgraph.Record}, interval::GenomicFeatures.GenomicInterval{Nothing}, null_value=1) :: Bedgraph.Record

    return Bedgraph.Record(
        GenomicFeatures.seqname(interval),
        GenomicFeatures.leftposition(interval),
        GenomicFeatures.rightposition(interval),
        null_value #Note: the default null value replacement of 0 is not useful as it does not show in IGV.
    )

end

function Base.convert(::Type{Bedgraph.Record}, interval::GenomicFeatures.GenomicInterval{T}) :: Bedgraph.Record where {T<:Real}

    return Bedgraph.Record(
        GenomicFeatures.seqname(interval),
        GenomicFeatures.leftposition(interval),
        GenomicFeatures.rightposition(interval),
        GenomicFeatures.metadata(interval)
    )

end

function Base.convert(::Type{Vector{Bedgraph.Record}}, data::Union{GenomicFeatures.GenomicIntervalCollection{I}, AbstractVector{I}}) :: Vector{Bedgraph.Record} where {T,I<:GenomicFeatures.AbstractGenomicInterval{T}}

    records = Vector{Bedgraph.Record}(undef, length(data))

    for (i, interval) in enumerate(data)

        record = convert(Bedgraph.Record, interval)

    	records[i] = record
    end

    return records
end

function Base.convert(::Type{GenomicFeatures.GenomicInterval{Nothing}}, record::Bedgraph.Record) :: GenomicFeatures.GenomicInterval{Nothing}

    return GenomicFeatures.GenomicInterval(
        record.chrom,
        record.first,
        record.last
    )
end

function Base.convert(::Type{GenomicFeatures.GenomicInterval{T}}, record::Bedgraph.Record) :: GenomicFeatures.GenomicInterval{T} where {T<:Real}

    return GenomicFeatures.GenomicInterval(
        record.chrom,
        record.first,
        record.last,
        '?',
        convert(T, record.value)
    )
end

function Base.convert(::Type{Vector{GenomicFeatures.GenomicInterval{T}}}, records::Vector{Bedgraph.Record}) :: Vector{GenomicFeatures.GenomicInterval{T}} where {T<:Union{Nothing, Real}}

    vec = Vector{GenomicFeatures.GenomicInterval{T}}(undef, length(records))

    for (i, record) in enumerate(records)
        interval = convert(GenomicFeatures.GenomicInterval{T}, record)
        vec[i] = interval
    end

    return vec
end

function Base.convert(::Type{GenomicFeatures.GenomicIntervalCollection{T}}, records::AbstractVector{Bedgraph.Record}) ::GenomicFeatures.GenomicIntervalCollection{GenomicFeatures.GenomicInterval{T}} where {T<:Union{Nothing, Real}}

    return convert(GenomicFeatures.GenomicIntervalCollection{GenomicFeatures.GenomicInterval{T}}, records)
end

function Base.convert(::Type{GenomicFeatures.GenomicIntervalCollection{I}}, records::AbstractVector{Bedgraph.Record}) :: GenomicFeatures.GenomicIntervalCollection{I} where {T<:Union{Nothing, Real}, I <:GenomicFeatures.AbstractGenomicInterval{T}}

	vec = convert(Vector{I}, records) #TODO: make iterator.

    return GenomicFeatures.GenomicIntervalCollection{I}(vec)
end

function Base.convert(::Type{V}, file::BedgraphFiles.BedgraphFile) :: V where {T<:Union{Nothing, Real},I<:GenomicFeatures.AbstractGenomicInterval{T},V<:AbstractVector{I}}

    records = Vector{Bedgraph.Record}(file)#TODO: make iterator.

    return convert(V, records)

end

"Short hand conversion"
function Base.convert(::Type{GenomicFeatures.GenomicIntervalCollection{T}}, file::BedgraphFiles.BedgraphFile) :: GenomicFeatures.GenomicIntervalCollection{GenomicFeatures.GenomicInterval{T}} where {T<:Union{Nothing, Real}}
    return convert(GenomicFeatures.GenomicIntervalCollection{GenomicFeatures.GenomicInterval{T}}, file)
end


function Base.convert(::Type{GenomicFeatures.GenomicIntervalCollection{I}}, file::BedgraphFiles.BedgraphFile) :: GenomicFeatures.GenomicIntervalCollection{I} where {T<:Union{Nothing, Real}, I<:GenomicFeatures.AbstractGenomicInterval{T}}

    vec = convert(Vector{I}, file) #TODO: pass iterator into GenomicIntervalCollection.

    return GenomicFeatures.GenomicIntervalCollection{I}(vec)
end


"Short hand conversion"
function GenomicFeatures.GenomicIntervalCollection{T}(data::Union{BedgraphFiles.BedgraphFile, AbstractVector{Bedgraph.Record}}) :: GenomicFeatures.GenomicIntervalCollection{GenomicFeatures.GenomicInterval{T}} where {T<:Union{Nothing, Real}}
	return GenomicFeatures.GenomicIntervalCollection{GenomicFeatures.GenomicInterval{T}}(data)
end

function GenomicFeatures.GenomicIntervalCollection{I}(data::Union{BedgraphFiles.BedgraphFile, AbstractVector{Bedgraph.Record}}) :: GenomicFeatures.GenomicIntervalCollection{I} where {T, I<:GenomicFeatures.AbstractGenomicInterval{T}}

	vec = convert(Vector{I}, data) #TODO: pass iterator into GenomicIntervalCollection.

	return GenomicFeatures.GenomicIntervalCollection(vec)

end
