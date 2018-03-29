module MatrixMath

using StaticArrays
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

const Vec = SVector
const Mat = SMatrix

export Vec2f
export Vec3f
export Vec4f

const Vec2f = Vec{2, Float32}
const Vec3f = Vec{3, Float32}
const Vec4f = Vec{4, Float32}

export Vec2i
export Vec3i
export Vec4i

const Vec2i = Vec{2, Int32}
const Vec3i = Vec{3, Int32}
const Vec4i = Vec{4, Int32}

export Vec2u
export Vec3u
export Vec4u

const Vec2u = Vec{2, UInt32}
const Vec3u = Vec{3, UInt32}
const Vec4u = Vec{4, UInt32}

export Mat2x2f
export Mat3x3f
export Mat4x4f

const Mat2x2f = Mat{2,2,Float32,4} #StaticArrays.SArray{Tuple{2,2},Float32,2,4}
const Mat3x3f = Mat{3,3,Float32,8} ##StaticArrays.SArray{Tuple{3,3},Float32,2,8}
const Mat4x4f = Mat{4,4,Float32,16} ##StaticArrays.SArray{Tuple{4,4},Float32,2,16}

export IMat2x2f
export IMat3x3f
export IMat4x4f

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

export AVec2f
export AVec3f
export AVec4f

const AVec2f = Array{Vec2f,1}
const AVec3f = Array{Vec3f,1}
const AVec4f = Array{Vec4f,1}

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
		zfn = 1/(zfar-znear)

		t = tan(fovy * 0.5)
    h = T(tan(fovy * pi / 360) * znear)
    w = T(h * aspect)

		left = -w
		right = w
		bottom = -h
		top = h

		frustum(-w, w, -h, h, znear, zfar)

    #Mat{4,4,T}([
    #    1/(aspect*t) 0 0 0;
    #    0 1/t 0 0;
    #    0 0 -(zfar+znear)*zfn -(2*zfar*znear)*zfn;
		#		0 0 -1 0;
    # ])
end

function frustum{T}(left::T, right::T, bottom::T, top::T, znear::T, zfar::T)
    (right == left || bottom == top || znear == zfar) && return eye(Mat{4,4,T})
    Mat{4,4,T}([
        2*znear/(right-left) 0 0 0;
        0 2*znear/(top-bottom) 0 0;
        (right+left)/(right-left) (top+bottom)/(top-bottom) (-(zfar+znear)/(zfar-znear)) -(2*znear*zfar) / (zfar-znear);
        0 0 -1 0
    ])
end

function translationmatrix{T}(t::Vec{3, T})
    Mat{4,4,T}([
        1 0 0 t[1];
        0 1 0 t[2];
        0 0 1 t[3];
				0 0 0 1;
    ])
end

function inverse_translationmatrix{T}(t::Vec{3, T})
    Mat{4,4,T}([
        1 0 0 0;
        0 1 0 0;
        0 0 1 0;
				t[1] t[2] t[3] 1;
    ])
end

function rotationmatrix{T}(t::Vec{3, T})
    Mat{4,4,T}([
        1 0 0 0;
        0 1 0 0;
        0 0 1 0;
				t[1] t[2] t[3] 1;
    ])
end

function scalingmatrix{T}(t::Vec{3, T})
    Mat{4,4,T}([
        t[1] 0 0 0;
        0 t[2] 0 0;
        0 0 t[3] 0;
				0 0 0 1;
    ])
end

function orthographicprojection{T}(left::T,right::T,bottom::T,top::T,znear::T,zfar::T)
    (right==left || bottom==top || znear==zfar) && return eye(Mat{4,4,T})
    Mat{4,4,T}([
        2/(right-left) 0 0 0;
        0 2/(top-bottom) 0 0;
        0 0 -2/(zfar-znear) 0;
				-(right+left)/(right-left) -(top+bottom)/(top-bottom) -(zfar+znear)/(zfar-znear) 1;
    ])
end

function lookat{T}(eye::Vec{3, T}, lookAt::Vec{3, T}, up::Vec{3, T})
    zaxis  = normalize(eye-lookAt)
    xaxis  = normalize(cross(up,    zaxis))
    yaxis  = normalize(cross(zaxis, xaxis))
    Mat{4,4,T}([
        xaxis[1] yaxis[1] zaxis[1] 0;
        xaxis[2] yaxis[2] zaxis[2] 0;
        xaxis[3] yaxis[3] zaxis[3] 0;
        -dot(xaxis,eye) -dot(yaxis,eye) -dot(zaxis,eye) 1
    ])
end

rotate{T}(angle::T, axis::Vec{3, T}) = rotationmatrix4(Quaternions.qrotation(convert(Array, axis), angle))
rotate{T}(v::Vec{2, T}, angle::T) = Vec{2,T}(v[1] * cos(angle) - v[2] * sin(angle), v[1] * sin(angle) + v[1] * cos(angle))

function rotationmatrix4{T}(q::Quaternions.Quaternion{T})
    sx, sy, sz = 2q.s*q.v1,  2q.s*q.v2,   2q.s*q.v3
    xx, xy, xz = 2q.v1^2,    2q.v1*q.v2,  2q.v1*q.v3
    yy, yz, zz = 2q.v2^2,    2q.v2*q.v3,  2q.v3^2
    Mat{4,4,T}([
        1-(yy+zz)	xy+sz				xz-sy				0;
        xy-sz				1-(xx+zz)	yz+sx				0;
        xz+sy				yz-sx				1-(xx+yy)	0;
        0 0 0 1
    ])
end

forwardVector4{T}(m::Mat{4,4,T}) = Vec{3, T}(m[3,1],m[3,2],m[3,3])
rightVector4{T}(m::Mat{4,4,T}) = Vec{3, T}(m[1,1],m[1,2],m[1,3])
upVector4{T}(m::Mat{4,4,T}) = Vec{3, T}(m[2,1],m[2,2],m[2,3])

function computeRotation{T}(rot::Vec{3,T})
	dirBackwards= Vec{3, T}(-1,0,0)
	dirRight = Vec{3, T}(0,0,1)
	dirUp = Vec{3, T}(0,1,0) #cross(dirRight, dirBackwards)

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

function scalematrix{T}(s::Vec{3, T})
    T0, T1 = zero(T), one(T)
    Mat{4,4,T}(
        (s[1],T0,  T0,  T0),
        (T0,  s[2],T0,  T0),
        (T0,  T0,  s[3],T0),
        (T0,  T0,  T0,  T1),
    )
end

translationmatrix_x{T}(x::T) = translationmatrix(Vec{3, T}(x, 0, 0))
translationmatrix_y{T}(y::T) = translationmatrix(Vec{3, T}(0, y, 0))
translationmatrix_z{T}(z::T) = translationmatrix(Vec{3, T}(0, 0, z))

function translationmatrix{T}(t::Vec{3, T})
    T0, T1 = zero(T), one(T)
    Mat(
        (T1,  T0,  T0,  T0),
        (T0,  T1,  T0,  T0),
        (T0,  T0,  T1,  T0),
        (t[1],t[2],t[3],T1),
    )
end

rotate{T}(angle::T, axis::Vec{3, T}) = rotationmatrix4(Quaternions.qrotation(convert(Array, axis), angle))

function rotationmatrix_x{T}(angle::T)
    T0, T1 = zero(T), one(T)
    Mat{4,4,T}(
        (T1, T0, T0, T0),
        (T0, cos(angle), sin(angle), T0),
        (T0, -sin(angle), cos(angle),  T0),
        (T0, T0, T0, T1)
    )
end
function rotationmatrix_y{T}(angle::T)
    T0, T1 = zero(T), one(T)
    Mat{4,4,T}(
        (cos(angle), T0, -sin(angle),  T0),
        (T0, T1, T0, T0),
        (sin(angle), T0, cos(angle), T0),
        (T0, T0, T0, T1)
    )
end
function rotationmatrix_z{T}(angle::T)
    T0, T1 = zero(T), one(T)
    Mat{4,4,T}(
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
    (right == left || bottom == top || znear == zfar) && return eye(Mat{4,4,T})
    T0, T1, T2 = zero(T), one(T), T(2)
    Mat{4,4,T}(
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
    (right==left || bottom==top || znear==zfar) && return eye(Mat{4,4,T})
    T0, T1, T2 = zero(T), one(T), T(2)
    Mat{4,4,T}(
        (T2/(right-left), T0, T0,  T0),
        (T0, T2/(top-bottom), T0,  T0),
        (T0, T0, -T2/(zfar-znear), T0),
        (-(right+left)/(right-left), -(top+bottom)/(top-bottom), -(zfar+znear)/(zfar-znear), T1)
    )
end
=#
end #MatrixMath
