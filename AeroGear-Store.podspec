#
# JBoss, Home of Professional Open Source
# Copyright ${year}, Red Hat, Inc., and individual contributors
# by the @authors tag. See the copyright.txt in the distribution for a
# full listing of individual contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
Pod::Spec.new do |s|
  s.name         = "AeroGear-Store"
  s.version      = "0.0.1"
  s.summary      = "CoreData Plugin for AeroGear."
  s.homepage     = "https://github.com/aerogear/aerogear-store-ios"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/aerogear/aerogear-store-ios.git', :branch => 'Plugin' }
  s.platform     = :ios, '5.0'
  s.source_files = 'AeroGear-Store/**/*.{h,m}'
  s.public_header_files = 'AeroGear-Store/AeroGearStore.h','AeroGear-Store/AGIncrementalStore.h','AeroGear-Store/AGIncrementalStoreHttpClient.h', 'AeroGear-Store/AGAuthenticationModule.h', 'AeroGear-Store/AGAuthenticator.h', 'AeroGear-Store/AGAuthConfig.h'
  s.requires_arc = true
  s.dependency 'AeroGear', '1.0.0.M1.20121115'
  s.dependency 'AFIncrementalStore'
end
