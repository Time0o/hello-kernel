#pragma once

#include <cstdint>
#include <type_traits>

namespace x86
{

namespace detail
{

template<typename T>
constexpr typename std::enable_if<std::is_integral<T>::value, bool>::type
is_uint_le32_t()
{ return std::is_unsigned<T>::value && sizeof(T) <= sizeof(uint32_t); }

template<typename T>
constexpr typename std::enable_if<std::is_enum<T>::value, bool>::type
is_uint_le32_t()
{ return is_uint_le32_t<typename std::underlying_type<T>::type>(); }

} // namespace detail

template<typename T>
T in(uint16_t port)
{
  static_assert(detail::is_uint_le32_t<T>());

  T data;
  asm ("in %1,%0"
       : "=a" (data)
       : "d" (port));
  return data;
}

template<typename T>
void ins(uint16_t port, uint32_t dest, uint32_t count)
{
  static_assert(detail::is_uint_le32_t<T>());

  T *dest_ptr = reinterpret_cast<T *>(dest);

  asm volatile("rep ins%z2"
               : "+D" (dest_ptr), "+c" (count), "=m" (*dest_ptr)
               : "d" (port)
               : "memory");
}

template<typename T>
void out(uint16_t port, T data)
{
  static_assert(detail::is_uint_le32_t<T>());

  asm ("out %0,%1"
       : : "a" (data), "d" (port));
}

} // namespace x86
