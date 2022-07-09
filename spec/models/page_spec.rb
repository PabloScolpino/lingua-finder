# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page, type: :model, vcr: {} do
  describe '.find_or_download' do
    let(:page_id) do
      page = create(:page, link: link)
      page.id.to_s
    end

    context 'a valid link' do
      let(:link) do
        'http://www.infobae.com/sociedad/2017/03/09/tucuman-la-iglesia-repudio-una-parodia-a-la-virgen-durante-la-marcha-de-mujeres/'
      end

      subject { Page.find_or_download_by(id: page_id) }

      it { is_expected.to be }
      it { is_expected.to have_attributes(link: link) }
      it 'has a content' do
        expect(subject.body).not_to be_empty
      end
    end

    context 'a link containing weird encoding' do
      let(:link) { 'http://educacionymemoria.educ.ar/primaria/category/vida-cotidiana-durante-la-dictadura/' }

      it 'does not raise an error' do
        # Thanks to mongodb storage
        expect { Page.find_or_download_by(id: page_id) }.not_to raise_error
      end
    end

    # TODO: this spec takes 20+ seconds to fail
    #         http timeout is involved and I am not sure if it is worth tetsting this
    # context 'an invalid link' do
    # let(:link) { 'http://somewherethatdoesnotexist.some.com/blabla/bla.html/' }
    # it 'raises an error' do
    # expect { Page.find_or_download(link) }.to raise_error(PageError)
    # end
    # end
  end
end
