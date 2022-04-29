{

    function abi_decode_t_address_fromMemory(offset, end) -> value {
        value := mload(offset)
        validator_revert_t_address(value)
    }

    function abi_decode_t_bool_fromMemory(offset, end) -> value {
        value := mload(offset)
        validator_revert_t_bool(value)
    }

    function abi_decode_tuple_t_address_fromMemory(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address_fromMemory(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_bool_fromMemory(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_bool_fromMemory(add(headStart, offset), dataEnd)
        }

    }

    function abi_encodeUpdatedPos_t_string_memory_ptr_to_t_string_memory_ptr(value0, pos) -> updatedPos {
        updatedPos := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr(value0, pos)
    }

    function abi_encode_t_address_to_t_address_fromStack_library(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    // string[] -> string[]
    function abi_encode_t_array$_t_string_memory_ptr_$dyn_memory_ptr_to_t_array$_t_string_memory_ptr_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
        let length := array_length_t_array$_t_string_memory_ptr_$dyn_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_array$_t_string_memory_ptr_$dyn_memory_ptr_fromStack(pos, length)
        let headStart := pos
        let tail := add(pos, mul(length, 0x20))
        let baseRef := array_dataslot_t_array$_t_string_memory_ptr_$dyn_memory_ptr(value)
        let srcPtr := baseRef
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {
            mstore(pos, sub(tail, headStart))
            let elementValue0 := mload(srcPtr)
            tail := abi_encodeUpdatedPos_t_string_memory_ptr_to_t_string_memory_ptr(elementValue0, tail)
            srcPtr := array_nextElement_t_array$_t_string_memory_ptr_$dyn_memory_ptr(srcPtr)
            pos := add(pos, 0x20)
        }
        pos := tail
        end := pos
    }

    function abi_encode_t_bool_to_t_bool_fromStack(value, pos) {
        mstore(pos, cleanup_t_bool(value))
    }

    function abi_encode_t_bool_to_t_bool_fromStack_library(value, pos) {
        mstore(pos, cleanup_t_bool(value))
    }

    function abi_encode_t_rational_100_by_1_to_t_uint256_fromStack_library(value, pos) {
        mstore(pos, convert_t_rational_100_by_1_to_t_uint256(value))
    }

    function abi_encode_t_rational_1_by_1_to_t_uint256_fromStack_library(value, pos) {
        mstore(pos, convert_t_rational_1_by_1_to_t_uint256(value))
    }

    function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr(value, pos) -> end {
        let length := array_length_t_string_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_string_memory_ptr(pos, length)
        copy_memory_to_memory(add(value, 0x20), pos, length)
        end := add(pos, round_up_to_mul_of_32(length))
    }

    function abi_encode_t_stringliteral_33a083ddf84e90d11c5db74ca7378560cfb0126686dda28b877f4d32300d997a_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 4)
        store_literal_in_memory_33a083ddf84e90d11c5db74ca7378560cfb0126686dda28b877f4d32300d997a(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_43527ceef6cf02afd6de6e6fd7dc1140649c529dd999e3216ca19aae52a46009_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 9)
        store_literal_in_memory_43527ceef6cf02afd6de6e6fd7dc1140649c529dd999e3216ca19aae52a46009(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_4aa1f787db3fcfa9f54b0253d689d521f7ac16850a0d189839b4a572076119bc_to_t_string_memory_ptr_fromStack_library(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, 29)
        store_literal_in_memory_4aa1f787db3fcfa9f54b0253d689d521f7ac16850a0d189839b4a572076119bc(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0_to_t_string_memory_ptr_fromStack_library(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, 14)
        store_literal_in_memory_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_a06538b932a313089ae566efd0e7e26dd4e72c52e77044e966d0526f069591e6_to_t_string_memory_ptr_fromStack_library(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, 13)
        store_literal_in_memory_a06538b932a313089ae566efd0e7e26dd4e72c52e77044e966d0526f069591e6(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_afb127f3091a592e4442d3cc2f229397fb413d593c528e8b3f7fb127b3c43be8_to_t_string_memory_ptr_fromStack_library(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, 28)
        store_literal_in_memory_afb127f3091a592e4442d3cc2f229397fb413d593c528e8b3f7fb127b3c43be8(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_b12f9c5bc4a82ca1ad7ddb67124872006aff2994f603ddbee11475a3ecd79c21_to_t_string_memory_ptr_fromStack_library(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, 14)
        store_literal_in_memory_b12f9c5bc4a82ca1ad7ddb67124872006aff2994f603ddbee11475a3ecd79c21(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_ce5b66e712fd209701b261bab5d02d6006f943c117c975776d7bc101e6ea1c86_to_t_string_memory_ptr_fromStack_library(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, 22)
        store_literal_in_memory_ce5b66e712fd209701b261bab5d02d6006f943c117c975776d7bc101e6ea1c86(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_stringliteral_fda446403d30f2bb15bf0f6e6a453eb8c51242c96883275950401463830444fd_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 10)
        store_literal_in_memory_fda446403d30f2bb15bf0f6e6a453eb8c51242c96883275950401463830444fd(pos)
        end := add(pos, 32)
    }

    function abi_encode_t_uint256_to_t_uint256_fromStack_library(value, pos) {
        mstore(pos, cleanup_t_uint256(value))
    }

    function abi_encode_tuple_t_address_t_address_t_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0__to_t_address_t_address_t_string_memory_ptr__fromStack_library_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_address_to_t_address_fromStack_library(value0,  add(headStart, 0))

        abi_encode_t_address_to_t_address_fromStack_library(value1,  add(headStart, 32))

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0_to_t_string_memory_ptr_fromStack_library( tail)

    }

    function abi_encode_tuple_t_bool__to_t_bool__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_bool_to_t_bool_fromStack(value0,  add(headStart, 0))

    }

    function abi_encode_tuple_t_bool_t_stringliteral_b12f9c5bc4a82ca1ad7ddb67124872006aff2994f603ddbee11475a3ecd79c21__to_t_bool_t_string_memory_ptr__fromStack_library_reversed(headStart , value0) -> tail {
        tail := add(headStart, 64)

        abi_encode_t_bool_to_t_bool_fromStack_library(value0,  add(headStart, 0))

        mstore(add(headStart, 32), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_b12f9c5bc4a82ca1ad7ddb67124872006aff2994f603ddbee11475a3ecd79c21_to_t_string_memory_ptr_fromStack_library( tail)

    }

    function abi_encode_tuple_t_rational_1_by_1__to_t_uint256__fromStack_library_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_rational_1_by_1_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

    }

    function abi_encode_tuple_t_stringliteral_33a083ddf84e90d11c5db74ca7378560cfb0126686dda28b877f4d32300d997a_t_stringliteral_43527ceef6cf02afd6de6e6fd7dc1140649c529dd999e3216ca19aae52a46009_t_stringliteral_fda446403d30f2bb15bf0f6e6a453eb8c51242c96883275950401463830444fd_t_array$_t_string_memory_ptr_$dyn_memory_ptr__to_t_string_memory_ptr_t_string_memory_ptr_t_string_memory_ptr_t_array$_t_string_memory_ptr_$dyn_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 128)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_33a083ddf84e90d11c5db74ca7378560cfb0126686dda28b877f4d32300d997a_to_t_string_memory_ptr_fromStack( tail)

        mstore(add(headStart, 32), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_43527ceef6cf02afd6de6e6fd7dc1140649c529dd999e3216ca19aae52a46009_to_t_string_memory_ptr_fromStack( tail)

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_fda446403d30f2bb15bf0f6e6a453eb8c51242c96883275950401463830444fd_to_t_string_memory_ptr_fromStack( tail)

        mstore(add(headStart, 96), sub(tail, headStart))
        tail := abi_encode_t_array$_t_string_memory_ptr_$dyn_memory_ptr_to_t_array$_t_string_memory_ptr_$dyn_memory_ptr_fromStack(value0,  tail)

    }

    function abi_encode_tuple_t_uint256_t_rational_100_by_1_t_stringliteral_a06538b932a313089ae566efd0e7e26dd4e72c52e77044e966d0526f069591e6__to_t_uint256_t_uint256_t_string_memory_ptr__fromStack_library_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

        abi_encode_t_rational_100_by_1_to_t_uint256_fromStack_library(value1,  add(headStart, 32))

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_a06538b932a313089ae566efd0e7e26dd4e72c52e77044e966d0526f069591e6_to_t_string_memory_ptr_fromStack_library( tail)

    }

    function abi_encode_tuple_t_uint256_t_uint256_t_stringliteral_4aa1f787db3fcfa9f54b0253d689d521f7ac16850a0d189839b4a572076119bc__to_t_uint256_t_uint256_t_string_memory_ptr__fromStack_library_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value1,  add(headStart, 32))

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_4aa1f787db3fcfa9f54b0253d689d521f7ac16850a0d189839b4a572076119bc_to_t_string_memory_ptr_fromStack_library( tail)

    }

    function abi_encode_tuple_t_uint256_t_uint256_t_stringliteral_afb127f3091a592e4442d3cc2f229397fb413d593c528e8b3f7fb127b3c43be8__to_t_uint256_t_uint256_t_string_memory_ptr__fromStack_library_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value1,  add(headStart, 32))

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_afb127f3091a592e4442d3cc2f229397fb413d593c528e8b3f7fb127b3c43be8_to_t_string_memory_ptr_fromStack_library( tail)

    }

    function abi_encode_tuple_t_uint256_t_uint256_t_stringliteral_ce5b66e712fd209701b261bab5d02d6006f943c117c975776d7bc101e6ea1c86__to_t_uint256_t_uint256_t_string_memory_ptr__fromStack_library_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 96)

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

        abi_encode_t_uint256_to_t_uint256_fromStack_library(value1,  add(headStart, 32))

        mstore(add(headStart, 64), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_ce5b66e712fd209701b261bab5d02d6006f943c117c975776d7bc101e6ea1c86_to_t_string_memory_ptr_fromStack_library( tail)

    }

    function allocate_unbounded() -> memPtr {
        memPtr := mload(64)
    }

    function array_dataslot_t_array$_t_string_memory_ptr_$dyn_memory_ptr(ptr) -> data {
        data := ptr

        data := add(ptr, 0x20)

    }

    function array_length_t_array$_t_string_memory_ptr_$dyn_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_length_t_string_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_nextElement_t_array$_t_string_memory_ptr_$dyn_memory_ptr(ptr) -> next {
        next := add(ptr, 0x20)
    }

    function array_storeLengthForEncoding_t_array$_t_string_memory_ptr_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_string_memory_ptr(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack_library(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function cleanup_t_address(value) -> cleaned {
        cleaned := cleanup_t_uint160(value)
    }

    function cleanup_t_bool(value) -> cleaned {
        cleaned := iszero(iszero(value))
    }

    function cleanup_t_uint160(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
    }

    function cleanup_t_uint256(value) -> cleaned {
        cleaned := value
    }

    function convert_t_rational_100_by_1_to_t_uint256(value) -> converted {
        converted := cleanup_t_uint256(value)
    }

    function convert_t_rational_1_by_1_to_t_uint256(value) -> converted {
        converted := cleanup_t_uint256(value)
    }

    function copy_memory_to_memory(src, dst, length) {
        let i := 0
        for { } lt(i, length) { i := add(i, 32) }
        {
            mstore(add(dst, i), mload(add(src, i)))
        }
        if gt(i, length)
        {
            // clear end
            mstore(add(dst, length), 0)
        }
    }

    function panic_error_0x41() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x41)
        revert(0, 0x24)
    }

    function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
        revert(0, 0)
    }

    function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
        revert(0, 0)
    }

    function round_up_to_mul_of_32(value) -> result {
        result := and(add(value, 31), not(31))
    }

    function store_literal_in_memory_33a083ddf84e90d11c5db74ca7378560cfb0126686dda28b877f4d32300d997a(memPtr) {

        mstore(add(memPtr, 0), "nume")

    }

    function store_literal_in_memory_43527ceef6cf02afd6de6e6fd7dc1140649c529dd999e3216ca19aae52a46009(memPtr) {

        mstore(add(memPtr, 0), "descriere")

    }

    function store_literal_in_memory_4aa1f787db3fcfa9f54b0253d689d521f7ac16850a0d189839b4a572076119bc(memPtr) {

        mstore(add(memPtr, 0), "2 should be greater than to 1")

    }

    function store_literal_in_memory_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0(memPtr) {

        mstore(add(memPtr, 0), "Invalid sender")

    }

    function store_literal_in_memory_a06538b932a313089ae566efd0e7e26dd4e72c52e77044e966d0526f069591e6(memPtr) {

        mstore(add(memPtr, 0), "Invalid value")

    }

    function store_literal_in_memory_afb127f3091a592e4442d3cc2f229397fb413d593c528e8b3f7fb127b3c43be8(memPtr) {

        mstore(add(memPtr, 0), "2 should be lesser than to 3")

    }

    function store_literal_in_memory_b12f9c5bc4a82ca1ad7ddb67124872006aff2994f603ddbee11475a3ecd79c21(memPtr) {

        mstore(add(memPtr, 0), "should be true")

    }

    function store_literal_in_memory_ce5b66e712fd209701b261bab5d02d6006f943c117c975776d7bc101e6ea1c86(memPtr) {

        mstore(add(memPtr, 0), "1 should be equal to 1")

    }

    function store_literal_in_memory_fda446403d30f2bb15bf0f6e6a453eb8c51242c96883275950401463830444fd(memPtr) {

        mstore(add(memPtr, 0), "google.com")

    }

    function validator_revert_t_address(value) {
        if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
    }

    function validator_revert_t_bool(value) {
        if iszero(eq(value, cleanup_t_bool(value))) { revert(0, 0) }
    }

}
