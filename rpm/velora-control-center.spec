Name:           velora-control-center
Version:        6.1.89
Release:        1%{?dist}
Summary:        Lingmo Control Center
License:        GPL-3.0-or-later
URL:            https://github.com/LingmoOS/velora-control-center
Source0:        velora-control-center-%{version}.tar.gz

BuildRequires:  gcc-c++
BuildRequires:  cmake >= 3.18
BuildRequires:  extra-cmake-modules
BuildRequires:  pkgconfig(Qt6Core)
BuildRequires:  pkgconfig(Qt6Gui)
BuildRequires:  pkgconfig(Qt6Widgets)
BuildRequires:  pkgconfig(Qt6Quick)
BuildRequires:  pkgconfig(Qt6QuickControls2)
BuildRequires:  pkgconfig(Qt6DBus)
BuildRequires:  pkgconfig(Qt6LinguistTools)
BuildRequires:  pkgconfig(dtk6core)
BuildRequires:  pkgconfig(dtk6gui)
BuildRequires:  pkgconfig(dtk6widget)
BuildRequires:  pkgconfig(gio-2.0)
BuildRequires:  pkgconfig(gio-unix-2.0)
BuildRequires:  pkgconfig(gsettings-qt)

%description
Control Center for the Lingmo desktop environment,
providing system settings and configuration management.

%prep
%autosetup -n %{name}-%{version}

%build
%cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=OFF \
    -DDVERSION=%{version}
%cmake_build

%install
%cmake_install

%files
%doc README.md
%license LICENSE*
%{_bindir}/dcc
%{_bindir}/control-center
%{_libdir}/dcc-plugins/
%{_datadir}/dde-control-center/
%{_datadir}/dbus-1/services/*.service
%{_datadir}/applications/dde-control-center.desktop
%{_datadir}/icons/hicolor/*/apps/*.png

%changelog
* Tue Jun 18 2025 LingmoOS Build System <dev@lingmo.os> - %{version}-1
- Initial RPM packaging for local source build
