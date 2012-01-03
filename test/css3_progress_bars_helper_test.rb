require 'minitest/autorun'
require 'nokogiri'
require 'action_view'
require './app/helpers/css3_progress_bars_helper'
include ActionView::Helpers
include ActionView::Context
include Css3ProgressBarsHelper

describe Css3ProgressBarsHelper do
  describe '#combo_progress_bar' do
    describe 'given a collection that contains an invalid percentage value' do
      it 'raises an ArgumentError' do
        proc {combo_progress_bar([1,2,888])}.must_raise ArgumentError
        proc {combo_progress_bar([1,2,'99999',4,5])}.must_raise ArgumentError
      end
    end
    describe 'given a collection of valid percentage values' do
      describe 'with the tiny option' do
        it 'sets the correct tiny classes in the divs' do
          doc = Nokogiri::HTML(combo_progress_bar([1,2,3,4], :tiny => true))
          doc.search('div.bar_container').first.attributes["class"].value.must_match /container_tiny/
          doc.search('div.bar_mortice').first.attributes["class"].value.must_match /mortice_tiny/
          doc.search('div.progress').first.attributes["class"].value.must_match /progress_tiny/
        end
      end

      it 'ignores any values not in the first five members of the collection' do
        Nokogiri::HTML(combo_progress_bar([1,2,3,4,5,6,7])).search('div').count.must_equal 7
      end

      it 'returns the correct number of divs' do
        Nokogiri::HTML(combo_progress_bar([1,2,3,4,5])).search('div').count.must_equal 7
        Nokogiri::HTML(combo_progress_bar([1,2,3,4])).search('div').count.must_equal 6
      end
    end
  end

  describe '#progress_bar' do
    describe 'given an invalid percentage value' do
      it 'raises an ArgumentError' do
        proc {progress_bar(101)}.must_raise ArgumentError
        proc {progress_bar(-1)}.must_raise ArgumentError
        proc {progress_bar('1000')}.must_raise ArgumentError
      end
    end

    describe 'given a valid percentage value' do
      describe 'with the color option' do
        describe 'set to an invalid color' do
          it 'sets no color classes in the divs' do
            doc = Nokogiri::HTML(progress_bar(55, :color => 'mauve'))
            doc.search('div.bar_container').first.attributes["class"].value.wont_match /mauve_container/
            doc.search('div.bar_mortice').first.attributes["class"].value.wont_match /mauve_mortice/
            doc.search('div.progress').first.attributes["class"].value.wont_match /mauve/
          end
        end

        describe 'set to a valid color' do
          it 'sets the correct color classes in the divs' do
            doc = Nokogiri::HTML(progress_bar(55, :color => 'blue'))
            doc.search('div.bar_container').first.attributes["class"].value.must_match /blue_container/
            doc.search('div.bar_mortice').first.attributes["class"].value.must_match /blue_mortice/
            doc.search('div.progress').first.attributes["class"].value.must_match /blue/
          end
        end
      end

      describe 'with the rounded option' do
        it 'sets the correct rounded classes in the divs' do
          doc = Nokogiri::HTML(progress_bar(55, :rounded => true))
          doc.search('div.bar_container').first.attributes["class"].value.must_match /rounded_bar_container/
          doc.search('div.bar_mortice').first.attributes["class"].value.must_match /rounded/
          doc.search('div.progress').first.attributes["class"].value.must_match /rounded/
        end
      end

      describe 'with the tiny option' do
        it 'sets the correct tiny classes in the divs' do
          doc = Nokogiri::HTML(progress_bar(55, :tiny => true))
          doc.search('div.bar_container').first.attributes["class"].value.must_match /container_tiny/
          doc.search('div.bar_mortice').first.attributes["class"].value.must_match /mortice_tiny/
          doc.search('div.progress').first.attributes["class"].value.must_match /progress_tiny/
        end
      end

      describe 'with no options' do
        it 'returns the correct number of divs' do
          Nokogiri::HTML(progress_bar(3)).search('div').count.must_equal 3
        end

        it 'sets the correct style in the progress div' do
          Nokogiri::HTML(progress_bar(44)).search('div.progress').first.attributes["style"].value.must_equal "width: 44%;"
          Nokogiri::HTML(progress_bar(88)).search('div.progress').first.attributes["style"].value.must_equal "width: 88%;"
        end
      end
    end
  end
end

