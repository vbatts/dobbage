
require 'Qt'

module Slackware
	module Gui
		class PackageInfoWidget < Qt::Label
			def initialize(parent = nil)
				super(parent)

				setFrameStyle(Qt::Frame::Sunken | Qt::Frame::StyledPanel)
				setAlignment(Qt::AlignLeft)
				setAutoFillBackground(true)

				setMinimumWidth(90)
				setMinimumHeight(50)
			end
		end # PackageInfoWidget
	end # Gui
end # Slackware
