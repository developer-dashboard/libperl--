// External includes

#include <string>
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include <exception>
#include <cstdio>
#include <stdint.h>

#include <boost/shared_ptr.hpp>
#include <boost/utility/enable_if.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/ptr_container/ptr_map.hpp>
#include <boost/mpl/logical.hpp>
#include <boost/utility/result_of.hpp>

#include <boost/type_traits/function_traits.hpp>
#include <boost/type_traits/remove_pointer.hpp>
#include <boost/type_traits/is_base_of.hpp>
#include <boost/type_traits/is_member_function_pointer.hpp>
#include <boost/type_traits/is_member_object_pointer.hpp>
#include <boost/type_traits/is_unsigned.hpp>
#include <boost/type_traits/is_signed.hpp>
#include <boost/type_traits/is_arithmetic.hpp>
#include <boost/type_traits/is_integral.hpp>
#include <boost/type_traits/is_floating_point.hpp>

#ifdef DEBUG
#include <cstdio>
#define debug(foo) std::fprintf(stderr, "In file %s on line %u: %s\n", __FILE__, __LINE__, foo)
#define debugf(foo, ...) std::fprintf(stderr, "In file %s on line %u: " foo "\n",  __FILE__, __LINE__,  __VA_ARGS__)
#else
#define debug(foo)
#define debugf(...)
#endif

// I split the header, to ease working with it.
#include <perl++/multiplicity.h>
#include <perl++/config.h>
#include <perl++/helpers.h>
#include <perl++/scalar.h>
#include <perl++/primitives.h>
#include <perl++/reference.h>
#include <perl++/array.h>
#include <perl++/hash.h>
#include <perl++/other.h>
#include <perl++/interpreter.h>
#include <perl++/typecasts.h>
