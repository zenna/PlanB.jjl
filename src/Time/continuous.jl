# "A continuous representation of time"
# struct ContinuousTime{T, R <: Real}
#   value::R
# end

# abstract type ContinuousDatePeriod{T <: Real} <: Dates.DatePeriod end 
# abstract type ContinuousTimePeriod{T <: Real} <: Dates.TimePeriod end 

# struct CDay{T} <: ContinuousDatePeriod{T}
#   value::T
# end

# struct CMonth{T} <: ContinuousDatePeriod{T}
#   value::T
# end

# struct CWeek{T} <: ContinuousDatePeriod{T}
#   value::T
# end

# struct CYear{T} <: ContinuousDatePeriod{T}
#   value::T
# end

# struct CHour{T} <: ContinuousTimePeriod{T}
#   value::T
# end

# struct CMicrosecond{T} <: ContinuousTimePeriod{T}
#   value::T
# end

# struct CMillisecond{T} <: ContinuousTimePeriod{T}
#   value::T
# end

# struct CMinute{T} <: ContinuousTimePeriod{T}
#   value::T
# end

# struct CNanosecond{T} <: ContinuousTimePeriod{T}
#   value::T
# end

# struct CSecond{T} <: ContinuousTimePeriod{T}
#   value::T
# end

# Dates._units(::ContinuousTimePeriod) = "some units"