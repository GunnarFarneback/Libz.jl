
import Zlib, GZip, Libz
include("gzbufferedstream.jl")

# Source:
# ftp://ftp.ensembl.org/pub/release-81/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz
const filename = "Homo_sapiens.GRCh38.cds.all.fa"
const gzfilename = "Homo_sapiens.GRCh38.cds.all.fa.gz"


# Test incrementally writing gzip data

function zlib_write()
    writer = Zlib.Writer(open("/dev/null", "w"), true)
    for line in eachline(open(filename))
        write(writer, line)
    end
    close(writer)
end


function gzip_write()
    writer = GZip.gzopen("/dev/null", "w")
    for line in eachline(open(filename))
        write(writer, line)
    end
    close(writer)
end


function libz_write()
    writer = Libz.ZlibOutputStream(open("/dev/null", "w"))
    for line in eachline(open(filename))
        write(writer, line)
    end
    close(writer)
end


zlib_write()
gzip_write()
libz_write()

println("WRITE:")
println("zlib")
@time zlib_write()
println("gzip")
@time gzip_write()
println("libz")
@time libz_write()


# Test reading gzip data line by line

function zlib_readline()
    reader = Zlib.Reader(open(gzfilename))
    for line in eachline(reader)
    end
end

function gzip_readline()
    reader = GZip.open(gzfilename)
    for line in eachline(reader)
    end
end

function gzbufferedstream_readline()
    reader = GZBufferedStream(GZip.open(gzfilename))
    for line in eachline(reader)
    end
end

function libz_readline()
    reader = Libz.ZlibInputStream(open(gzfilename))
    for line in eachline(reader)
    end
end

zlib_readline()
gzip_readline()
gzbufferedstream_readline()
libz_readline()

println("READ LINE:")
println("zlib")
@time zlib_readline()
println("gzip")
@time gzip_readline()
println("gzbufferedstream")
@time gzbufferedstream_readline()
println("libz")
@time libz_readline()


# Test reading gzip data byte by byte

function zlib_readbyte()
    reader = Zlib.Reader(open(gzfilename))
    while !eof(reader)
        read(reader, UInt8)
    end
end

function gzip_readbyte()
    reader = GZip.open(gzfilename)
    while !eof(reader)
        read(reader, UInt8)
    end
end

function gzbufferedstream_readbyte()
    reader = GZBufferedStream(GZip.open(gzfilename))
    while !eof(reader)
        read(reader, UInt8)
    end
end

function libz_readbyte()
    reader = Libz.ZlibInputStream(open(gzfilename))
    while !eof(reader)
        read(reader, UInt8)
    end
end


zlib_readbyte()
gzip_readbyte()
gzbufferedstream_readbyte()
libz_readbyte()

println("READ BYTE:")
println("zlib")
@time zlib_readbyte()
println("gzip")
@time gzip_readbyte()
println("gzbufferedstream")
@time gzbufferedstream_readbyte()
println("libz")
@time libz_readbyte()
