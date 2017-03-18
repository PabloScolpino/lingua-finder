require 'rails_helper'

RSpec.describe Page, type: :model, vcr: {} do

  describe '.find_or_download' do

    context 'a valid link' do
      let(:link) { 'http://www.infobae.com/sociedad/2017/03/09/tucuman-la-iglesia-repudio-una-parodia-a-la-virgen-durante-la-marcha-de-mujeres/' }
      subject { Page.find_or_download(link) }

      it { is_expected.to be }
      it { is_expected.to have_attributes(link: link) }
      it 'has a content' do
        expect(subject.body).not_to be_empty
      end
    end

    context 'a link containing weird encoding' do
      let(:link) { 'http://educacionymemoria.educ.ar/primaria/category/vida-cotidiana-durante-la-dictadura/' }

      it 'raises an error' do
        expect { Page.find_or_download(link) }.to raise_error(PageError)
      end

    end

    context 'an invalid link' do
      let(:link) { 'http://somewherethatdoesnotexist.some.com/blabla/bla.html/' }

      it 'raises an error' do
        expect { Page.find_or_download(link) }.to raise_error(PageError)
      end

    end
  end
end
