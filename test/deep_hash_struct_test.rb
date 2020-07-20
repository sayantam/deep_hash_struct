require "test_helper"

describe DeepHashStruct do
  include DeepHashStruct

  it 'should have a version number' do
    refute_nil ::DeepHashStruct::VERSION
  end

  it 'should convert a deeply nested hash' do
    nest = {
      x: 1,
      y: {
        z: 2,
        f: {
          g: 3,
          h: 8
        }
      },
      a: {
        b: {
          c: {
            d: [4, 5, 6],
            k: [deep_struct(foo: 'bar'), deep_struct(foo: 'baz')]
          },
          e: 7,
          i: {
            j: 9
          }
        }
      }
    }

    obj = deep_struct(nest)

    assert_equal(obj.x, 1)
    assert_equal(obj.y.z, 2)
    assert_equal(obj.y.f.g, 3)
    assert_equal(obj.y.f.h, 8)
    assert_equal(obj.a.b.e, 7)
    assert_equal(obj.a.b.c.d, [4, 5, 6])
    assert_equal(obj.a.b.i.j, 9)
    assert_equal(obj.a.b.c.k[0].foo, 'bar')
    assert_equal(obj.a.b.c.k[1].foo, 'baz')
  end

  it 'should convert a single level hash' do
    obj = deep_struct({foo: 'bar', baz: 'qux'})
    assert_equal('bar', obj.foo)
    assert_equal('qux', obj.baz)
  end

  it 'should not alter the input' do
    nest = { z: 2 }
    input = { x: 1, y: nest }
    obj = deep_struct(input)
    assert_equal(2, obj.y.z)
    assert_same(nest, input[:y])
  end

  it 'should convert array of hashes' do
    nest = { foo: [{ x: 1 }, { y: { z: 2 } }] }
    obj = deep_struct(nest)
    assert_equal(1, obj.foo[0].x)
    assert_equal(2, obj.foo[1].y.z)
  end

  it 'should convert array of hashes of array of hashes' do
    nest = { foo: [{ x: [{ y: { z: 1 } }] }] }
    obj = deep_struct(nest)
    assert_equal(1, obj.foo[0].x[0].y.z)
  end

  it 'should convert multiple nested array of hashes' do
    nest = { foo: [{ x: [{ y: { z: [{ bar: 1 }] } }] }] }
    obj = deep_struct(nest)
    assert_equal(1, obj.foo[0].x[0].y.z[0].bar)
  end

  it 'should convert a double nested array' do
    nest = { foo: { bar: [{ x: 1 }]} }
    obj = deep_struct(nest)
    assert_equal(1, obj.foo.bar[0].x)
  end
end
