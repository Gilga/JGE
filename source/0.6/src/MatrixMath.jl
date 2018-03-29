module MatrixMath

import Base: +, -, *, /, \, ^, %, normalize 

using StaticArrays
#using StaticArrays.ImmutableArrays
using Quaternions

export array
export avec

# converts to normal array
array(x::AbstractArray) = convert(array(typeof(x)),vec(x))
array{T<:AbstractArray}(::Type{T}) = Array{array(eltype(T)),1};
array{T}(::Type{T}) = T;

# converts to one-dim normal array (faster than using vcat(x...) only! you need to convert into normal array first!)
avec(x::AbstractArray) = vcat(array(x)...)

export Vec
export Mat

Vec = SVector
Mat = SMatrix

export Vec1f
export Vec2f
export Vec3f
export Vec4f

mutable  struct Vec1{T} <: FieldVector{1, T}
		x::T
end

mutable  struct Vec2{T} <: FieldVector{2, T}
		x::T
		y::T
end

mutable  struct Vec3{T} <: FieldVector{3, T}
		x::T
		y::T
		z::T
end

mutable struct Vec4{T} <: FieldVector{4, T}
		x::T
		y::T
		z::T
		w::T
end

Vec1{T}() where T = Vec1{T}(0)
Vec1{T}(v::T) where T = Vec1{T}(v)
Vec1{T}(v::Number) where T<:Number = Vec1{T}(v)
#Vec1{T}(v::Vec1{T}) where T = Vec1{T}(v.x)

Vec2{T}() where T = Vec2{T}(0,0)
Vec2{T}(v::T) where T = Vec2{T}(v,v)
Vec2{T}(v::Number) where T<:Number = Vec2{T}(v,v)
#Vec2{T}(v::Vec2{T}) where T = Vec2{T}(v.x,v.y)

Vec3{T}() where T = Vec3{T}(0,0,0)
Vec3{T}(v::T) where T = Vec3{T}(v,v,v)
Vec3{T}(v::Number) where T<:Number = Vec3{T}(v,v,v)
#Vec3{T}(v::Vec3{T}) where T = Vec3{T}(v.x,v.y,v.z)

Vec4{T}() where T = Vec4{T}(0,0,0,0)
Vec4{T}(v::T) where T = Vec4{T}(v,v,v,v)
Vec4{T}(v::Number) where T<:Number = Vec4{T}(v,v,v,v)
#Vec4{T}(v::Vec4{T}) where T = Vec4{T}(v.x,v.y,v.z,v.w)

Vec1f = Vec1{Float32}
Vec2f = Vec2{Float32}
Vec3f = Vec3{Float32}
Vec4f = Vec4{Float32}

+{T}(a::Vec2{T}, b::Vec2{T}) = Vec2(SVector(a)+SVector(b))
+{T}(a::Vec3{T}, b::Vec3{T}) = Vec3(SVector(a)+SVector(b))

-{T}(a::Vec2{T}, b::Vec2{T}) = Vec2(SVector(a)+SVector(b))
-{T}(a::Vec3{T}, b::Vec3{T}) = Vec3(SVector(a)+SVector(b))

normalize{T}(v::Vec2{T}) = Vec2(normalize(SVector(v)))
normalize{T}(v::Vec3{T}) = Vec3(normalize(SVector(v)))

function operator{N, T}(op::Function,a::SVector{N, T}, b::SVector{N, T})
	m = zeros(T,N,N)
	for ai=1:N
		for bi=1:N
			r = op(a[ai],b[bi])
			if !isa(r,T) r = round(r) end # fix: round(Int / Int = Float)
			m[ai,bi]=r
		end
	end
	SMatrix{N,N,T,N*N}(m) #* ones(SVector{N, T})
end

function operator2{N, T}(op::Function,a::SVector{N, T}, b::SVector{N, T})
	v = zeros(T,N)
	for ai=1:N
		r = op(a[ai],b[ai])
		if !isa(r,T) r = round(r) end # fix: round(Int / Int = Float)
		v[ai]=r
	end
	SVector(v...)
end

# works only for multiplication
#a = repmat(a, 1, N)
#b = flipdim(rotr90(repmat(b, 1, N)),2) #rotr90flipdim2(repmat(b, 1, N))
#op(a,b) #/ 2

*{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(*,a,b)
/{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(/,a,b)
\{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(\,a,b)
^{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(^,a,b)
%{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator(%,a,b)

export scale
scale{N, T}(a::SVector{N, T}, b::SVector{N, T}) = operator2(*,a,b)

scale{T}(a::Vec2{T}, b::Vec2{T}) = Vec2(scale(SVector(a),SVector(b)))
scale{T}(a::Vec3{T}, b::Vec3{T}) = Vec3(scale(SVector(a),SVector(b)))

export Vec1i
export Vec2i
export Vec3i
export Vec4i

Vec1i = Vec2{Int32}
Vec2i = Vec2{Int32}
Vec3i = Vec3{Int32}
Vec4i = Vec4{Int32}

export Vec1u
export Vec2u
export Vec3u
export Vec4u

Vec1u = Vec1{UInt32}
Vec2u = Vec2{UInt32}
Vec3u = Vec3{UInt32}
Vec4u = Vec4{UInt32}

export AIndex
AIndex = Array{UInt32,1}

export AVec1f
export AVec2f
export AVec3f
export AVec4f

AVec1f = Array{Vec1f,1}
AVec2f = Array{Vec2f,1}
AVec3f = Array{Vec3f,1}
AVec4f = Array{Vec4f,1}

Mat1x1{T} = SMatrix{1,1,T,1}
Mat1x2{T} = SMatrix{1,2,T,2}
Mat1x3{T} = SMatrix{1,3,T,3}
Mat1x4{T} = SMatrix{1,4,T,4}

Mat2x1{T} = SMatrix{2,1,T,2}
Mat2x2{T} = SMatrix{2,2,T,4}
Mat2x3{T} = SMatrix{2,3,T,6}
Mat2x4{T} = SMatrix{2,4,T,8}

Mat3x1{T} = SMatrix{3,1,T,3}
Mat3x2{T} = SMatrix{3,2,T,6}
Mat3x3{T} = SMatrix{3,3,T,9}
Mat3x4{T} = SMatrix{3,4,T,12}

Mat4x1{T} = SMatrix{4,1,T,4}
Mat4x2{T} = SMatrix{4,2,T,8}
Mat4x3{T} = SMatrix{4,3,T,12}
Mat4x4{T} = SMatrix{4,4,T,16}

export Mat1x1f
export Mat1x2f
export Mat1x3f
export Mat1x4f

export Mat2x1f
export Mat2x2f
export Mat2x3f
export Mat2x4f

export Mat3x1f
export Mat3x2f
export Mat3x3f
export Mat3x4f

export Mat4x1f
export Mat4x2f
export Mat4x3f
export Mat4x4f

Mat1x1f = Mat1x1{Float32}
Mat1x2f = Mat1x2{Float32}
Mat1x3f = Mat1x3{Float32}
Mat1x4f = Mat1x4{Float32}

Mat2x1f = Mat2x1{Float32}
Mat2x2f = Mat2x2{Float32}
Mat2x3f = Mat2x3{Float32}
Mat2x4f = Mat2x4{Float32}

Mat3x1f = Mat3x1{Float32}
Mat3x2f = Mat3x2{Float32}
Mat3x3f = Mat3x3{Float32}
Mat3x4f = Mat3x4{Float32}

Mat4x1f = Mat4x1{Float32}
Mat4x2f = Mat4x2{Float32}
Mat4x3f = Mat4x3{Float32}
Mat4x4f = Mat4x4{Float32}

export IMat1x1f
export IMat2x2f
export IMat3x3f
export IMat4x4f

const IMat1x1f = @SMatrix [
	1f0;
]

const IMat2x2f = @SMatrix [
	1f0 0 ;
	0 1f0 ;
]

const IMat3x3f = @SMatrix [
	1f0 0 0 ;
	0 1f0 0 ;
	0 0 1f0 ;
]

const IMat4x4f = @SMatrix [
	1f0 0 0 0 ;
	0 1f0 0 0 ;
	0 0 1f0 0 ;
	0 0 0 1f0 ;
]

#t = MatrixMath.translationmatrix(Vec3f(0,0,-5))
#c = MatrixMath.lookat(Vec3f(sin(-(cursorpos[1])*6.3),0,1-cos((cursorpos[1])*6.3)),Vec3f(0,0,1), Vec3f(0,1,0))
#c = MatrixMath.rotate(-sin(-0.5f0+cursorpos[1]),Vec3f(0,1,0))

export rotr90flipdim2
rotr90flipdim2(x::AbstractArray) = flipdim(rotr90(x),2)

function convertMatrixToArray(values::AbstractArray)
	dims=ndims(values)
	elems=dims > 1 ? size(values)[dims] : 1
	values=avec(values) #wow! < 0.05 sec for > 1000 vertices!
	#print("vcat: "); @time v=vcat(values...) #end # convert to one dimensional array
	#print("convert: "); @time c=convert(Array{typeof(v[1]),1},v)
	(values, elems)
end

#c = FPSViewRH(normalize(Vec3f(0,0,1)),(cursorpos[1]-0.5f0)*3,(cursorpos[2]-0.5f0) * 3)
function FPSViewRH(eye::Any, yaw::Float32, pitch::Float32)
    # If the pitch and yaw angles are in degrees,
    # they need to be converted to radians. Here
    # I assume the values are already converted to radians.
    cosPitch = cos(pitch)
    sinPitch = sin(pitch)
    cosYaw = cos(yaw)
    sinYaw = sin(yaw)

    xaxis = Vec3f( cosYaw, 0, -sinYaw )
    yaxis = Vec3f( sinYaw * sinPitch, cosPitch, cosYaw * sinPitch )
    zaxis = Vec3f( sinYaw * cosPitch, -sinPitch, cosPitch * cosYaw )

    # Create a 4x4 view matrix from the right, up, forward and eye position vectors
    Mat{4,4,Float32}([
      xaxis[1] yaxis[1] zaxis[1] -dot(xaxis,eye)*0;
      xaxis[2] yaxis[2] zaxis[2] -dot(yaxis,eye)*0;
      xaxis[3] yaxis[3] zaxis[3] -dot(zaxis,eye)*0;
      -dot(xaxis,eye) -dot(yaxis,eye) -dot(zaxis,eye) 1;
    ])
end

function perspectiveprojection{T}(fovy::T, aspect::T, znear::T, zfar::T)
		(znear == zfar) && error("znear ($znear) must be different from tfar ($zfar)")

		t = tan(fovy * 0.5)
    h = T(tan(fovy * pi / 360) * znear)
    w = T(h * aspect)

		left = -w
		right = w
		bottom = -h
		top = h

		frustum(-w, w, -h, h, znear, zfar)

		#		zfn = 1/(zfar-znear)
    #Mat4x4{T}([
    #    1/(aspect*t) 0 0 0;
    #    0 1/t 0 0;
    #    0 0 -(zfar+znear)*zfn -(2*zfar*znear)*zfn;
		#		0 0 -1 0;
    # ])
end

function frustum{T}(left::T, right::T, bottom::T, top::T, znear::T, zfar::T)
    (right == left || bottom == top || znear == zfar) && return eye(Mat4x4{T})
    Mat4x4{T}([
        2*znear/(right-left) 0 0 0;
        0 2*znear/(top-bottom) 0 0;
        (right+left)/(right-left) (top+bottom)/(top-bottom) (-(zfar+znear)/(zfar-znear)) -(2*znear*zfar) / (zfar-znear);
        0 0 -1 0
    ])
end

function orthographicprojection{T}(fovy::T, aspect::T, znear::T, zfar::T)
		(znear == zfar) && error("znear ($znear) must be different from tfar ($zfar)")
	
		t = tan(fovy * 0.5)
    h = T(tan(fovy * pi / 360) * znear)
    w = T(h * aspect)

		left = -w
		right = w
		bottom = -h
		top = h

		orthographicprojection(-w, w, -h, h, znear, zfar)
end

function orthographicprojection{T}(left::T,right::T,bottom::T,top::T,znear::T,zfar::T)
    (right==left || bottom==top || znear==zfar) && return eye(Mat4x4{T})
    Mat4x4{T}([
        2/(right-left) 0 0 0;
        0 2/(top-bottom) 0 0;
        0 0 -2/(zfar-znear) 0;
				-(right+left)/(right-left) -(top+bottom)/(top-bottom) -(zfar+znear)/(zfar-znear) 1;
    ])
end

function translationmatrix{T}(t::Vec3{T})
    Mat4x4{T}([
        1 0 0 t[1];
        0 1 0 t[2];
        0 0 1 t[3];
				0 0 0 1;
    ])
end

function inverse_translationmatrix{T}(t::Vec3{T})
    Mat4x4{T}([
        1 0 0 0;
        0 1 0 0;
        0 0 1 0;
				t[1] t[2] t[3] 1;
    ])
end

function rotationmatrix{T}(t::Vec3{T})
    Mat4x4{T}([
        1 0 0 0;
        0 1 0 0;
        0 0 1 0;
				t[1] t[2] t[3] 1;
    ])
end

function scalingmatrix{T}(t::Vec3{T})
    Mat4x4{T}([
        t[2] 0 0 0;
        0 t[2] 0 0;
        0 0 t[3] 0;
				0 0 0 1;
    ])
end


function lookat{T}(eye::Vec3{T}, lookAt::Vec3{T}, up::Vec3{T})
    zaxis  = normalize(eye-lookAt)
    xaxis  = normalize(cross(up,    zaxis))
    yaxis  = normalize(cross(zaxis, xaxis))
    Mat4x4{T}([
        xaxis[1] yaxis[1] zaxis[1] 0;
        xaxis[2] yaxis[2] zaxis[2] 0;
        xaxis[3] yaxis[3] zaxis[3] 0;
        -dot(xaxis,eye) -dot(yaxis,eye) -dot(zaxis,eye) 1
    ])
end

rotate{T}(angle::T, axis::Vec3{T}) = rotationmatrix4(Quaternions.qrotation(convert(Array, axis), angle))
rotate{T}(v::Vec2{T}, angle::T) = Vec2{T}(v[1] * cos(angle) - v[2] * sin(angle), v[1] * sin(angle) + v[1] * cos(angle))

function rotationmatrix4{T}(q::Quaternions.Quaternion{T})
    sx, sy, sz = 2q.s*q.v1,  2q.s*q.v2,   2q.s*q.v3
    xx, xy, xz = 2q.v1^2,    2q.v1*q.v2,  2q.v1*q.v3
    yy, yz, zz = 2q.v2^2,    2q.v2*q.v3,  2q.v3^2
    Mat4x4{T}([
        1-(yy+zz)	xy+sz				xz-sy				0;
        xy-sz				1-(xx+zz)	yz+sx				0;
        xz+sy				yz-sx				1-(xx+yy)	0;
        0 0 0 1
    ])
end

forwardVector4{T}(m::Mat4x4{T}) = Vec3{T}(m[3,1],m[3,2],m[3,3])
rightVector4{T}(m::Mat4x4{T}) = Vec3{T}(m[1,1],m[1,2],m[1,3])
upVector4{T}(m::Mat4x4{T}) = Vec3{T}(m[2,1],m[2,2],m[2,3])

function computeRotation{T}(rot::Vec3{T})
	dirBackwards= Vec3{T}(-1,0,0)
	dirRight = Vec3{T}(0,0,1)
	dirUp = Vec3{T}(0,1,0) #cross(dirRight, dirBackwards)

	q = Quaternions.qrotation(convert(Array, dirRight), rot[3]) *
	Quaternions.qrotation(convert(Array, dirUp), rot[1]) *
	Quaternions.qrotation(convert(Array, dirBackwards), rot[2])

	rotationmatrix4(q)
end

#=
using GeometryTypes

function toOneArray{S1,S2,T}(m::Mat{S1,S2,T})
	a = T[]
	l(x,y) = (push!(a, x); y)
	push!(a, reduce(l, convert(Array{T,}, m)))
	a
end

function scalematrix{T}(s::Vec3{T})
    T0, T1 = zero(T), one(T)
    Mat4x4{T}(
        (s[1],T0,  T0,  T0),
        (T0,  s[2],T0,  T0),
        (T0,  T0,  s[3],T0),
        (T0,  T0,  T0,  T1),
    )
end

translationmatrix_x{T}(x::T) = translationmatrix(Vec3{T}(x, 0, 0))
translationmatrix_y{T}(y::T) = translationmatrix(Vec3{T}(0, y, 0))
translationmatrix_z{T}(z::T) = translationmatrix(Vec3{T}(0, 0, z))

function translationmatrix{T}(t::Vec3{T})
    T0, T1 = zero(T), one(T)
    Mat(
        (T1,  T0,  T0,  T0),
        (T0,  T1,  T0,  T0),
        (T0,  T0,  T1,  T0),
        (t[1],t[2],t[3],T1),
    )
end

rotate{T}(angle::T, axis::Vec3{T}) = rotationmatrix4(Quaternions.qrotation(convert(Array, axis), angle))

function rotationmatrix_x{T}(angle::T)
    T0, T1 = zero(T), one(T)
    Mat4x4{T}(
        (T1, T0, T0, T0),
        (T0, cos(angle), sin(angle), T0),
        (T0, -sin(angle), cos(angle),  T0),
        (T0, T0, T0, T1)
    )
end
function rotationmatrix_y{T}(angle::T)
    T0, T1 = zero(T), one(T)
    Mat4x4{T}(
        (cos(angle), T0, -sin(angle),  T0),
        (T0, T1, T0, T0),
        (sin(angle), T0, cos(angle), T0),
        (T0, T0, T0, T1)
    )
end
function rotationmatrix_z{T}(angle::T)
    T0, T1 = zero(T), one(T)
    Mat4x4{T}(
        (cos(angle), sin(angle), T0, T0),
        (-sin(angle), cos(angle),  T0, T0),
        (T0, T0, T1, T0),
        (T0, T0, T0, T1)
    )
end
#=
    Create view frustum
    Parameters
    ----------
        left : float
         Left coordinate of the field of view.
        right : float
         Left coordinate of the field of view.
        bottom : float
         Bottom coordinate of the field of view.
        top : float
         Top coordinate of the field of view.
        znear : float
         Near coordinate of the field of view.
        zfar : float
         Far coordinate of the field of view.
    Returns
    -------
        M : array
         View frustum matrix (4x4).
=#
function frustum{T}(left::T, right::T, bottom::T, top::T, znear::T, zfar::T)
    (right == left || bottom == top || znear == zfar) && return eye(Mat4x4{T})
    T0, T1, T2 = zero(T), one(T), T(2)
    Mat4x4{T}(
        (T2 * znear / (right - left), T0, T0, T0),
        (T0, T2 * znear / (top - bottom), T0, T0),
        ((right + left) / (right - left), (top + bottom) / (top - bottom), -(zfar + znear) / (zfar - znear), -T1),
        (T0, T0, (-T2 * znear * zfar) / (zfar - znear), T0)
    )
end

perspectiveprojection{T}(wh::SimpleRectangle, fov::T, near::T, far::T) = perspectiveprojection(fov, T(wh.w/wh.h), near, far)
function perspectiveprojection{T}(fovy::T, aspect::T, znear::T, zfar::T)
    (znear == zfar) && error("znear ($znear) must be different from tfar ($zfar)")
    h = T(tan(fovy / 360.0 * pi) * znear)
    w = T(h * aspect)
    frustum(-w, w, -h, h, znear, zfar)
end

orthographicprojection{T}(wh::SimpleRectangle, near::T, far::T) =
    orthographicprojection(zero(T), T(wh.w), zero(T), T(wh.h), near, far)

function orthographicprojection{T}(
        left  ::T, right::T,
        bottom::T, top  ::T,
        znear ::T, zfar ::T
    )
    (right==left || bottom==top || znear==zfar) && return eye(Mat4x4{T})
    T0, T1, T2 = zero(T), one(T), T(2)
    Mat4x4{T}(
        (T2/(right-left), T0, T0,  T0),
        (T0, T2/(top-bottom), T0,  T0),
        (T0, T0, -T2/(zfar-znear), T0),
        (-(right+left)/(right-left), -(top+bottom)/(top-bottom), -(zfar+znear)/(zfar-znear), T1)
    )
end
=#
end #MatrixMath
