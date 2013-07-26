require_relative '../spec_helper'

describe "rspec-mock thread safety tests" do
  context "stubbing a method on a double and then calling it from another thread" do
    let(:thing){ double }

    it "should know the method was stubbed" do
      thing.stub(:foo)
      thr = Thread.new do
        thing.foo
      end
      thr.join
      expect(thing).to have_received(:foo)
    end
  end

  context "stubbing a method on a double and then passing it in to an object that lives in another thread" do
    it "should know the method was stubbed" do
      $yarr_global_1 = false
      thr = Thread.new do
        until $yarr_global_1
          # neg...
        end
        $yarr_global_1.foo
      end
      thing = double
      thing.stub(:foo)
      $yarr_global_1 = thing
      thr.join
      expect(thing).to have_received(:foo)
    end
  end
end
