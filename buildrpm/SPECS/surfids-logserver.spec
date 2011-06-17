Summary: The logging server for the SURFids framework.
Name: surfids-logserver
Version: 3.10
Release: 1%{?dist}
License: GPL
Group: Applications/Internet
Source: surfids-logserver-3.10.tar.gz
URL: http://ids.surfnet.nl/
BuildRoot: /root/rpmbuild/BUILD/surfids-logserver-3.10/
BuildArch: noarch
Requires: postgresql >= 8.3, httpd >= 2, mod_auth_pgsql, sendmail, xalan-j2, perl, php, php-pgsql, perl-DBI, perl-DBD-Pg, php-gd, gnupg, perl-IO-Socket-SSL

%define surfinstall /opt/surfnetids
%define surfconfig /etc/surfnetids
%define surflog /var/log/surfids
%define builddir %{_topdir}/TMP/surfids-logserver-3.10
%define fullpack surfids-logserver-3.10

%description
The logserver component of the SURFids framework.

%prep
%setup -q
%install

install -m 755 -d %{builddir}%{surfinstall}
install -m 755 -d %{builddir}%{surfconfig}
install -m 755 -d %{builddir}%{surflog}
install -m 755 -d %{builddir}/etc/cron.d/
install -m 755 -d %{builddir}/etc/httpd/conf.d/
mv -f * %{builddir}%{surfinstall}
mv -f %{builddir}%{surfinstall}/surfnetids-log.conf %{builddir}%{surfconfig}/
mv -f %{builddir}%{surfinstall}/surfnetids-log-apache.conf %{builddir}%{surfconfig}/
install -m 644 %{builddir}%{surfinstall}/cron.d %{builddir}/etc/cron.d/surfids-logserver
install -m 644 %{builddir}%{surfinstall}/htaccess.dist %{builddir}%{surfinstall}/webinterface/.htaccess

# Build a manifest of the RPM's directory hierarchy.
echo "%%defattr(-, root, root)" >MANIFEST
(cd %{builddir}; find . -type f -or -type l | sed -e s/^.// -e /^$/d) >>MANIFEST
echo "%{surfinstall}/MANIFEST" >>MANIFEST

mv -f %{builddir}/* .
mv -f MANIFEST ./%{surfinstall}

%clean

%post
ln -s %{surfconfig}/surfnetids-log-apache.conf /etc/httpd/conf.d/surfids-logserver.conf

%files -f %{_topdir}/BUILD/%{fullpack}/opt/surfnetids/MANIFEST

%changelog
* Fri Jun 17 2011 SURFids Development Team <ids at, surfnet.nl> 3.10-1
- SURFids 3.10.
* Wed Aug 26 2009 SURFids Development Team <ids at, surfnet.nl> 3.02-1
- Fixed bug #176.
* Fri Aug 21 2009 SURFids Development Team <ids at, surfnet.nl> 3.01-1
- Fixed RSS bug. (#168)
* Wed Aug 19 2009 SURFids Development Team <ids at, surfnet.nl> 3.0-1
- Flash graphs.
- Centralized logging of all scripts via the webinterface (admin only).
- Sensor grouping.
- Mail reports with UTC time format.
- The ability to always let a mail report even if there's nothing to report. Useful for automated systems receiving the emails.
- Home page now configurable.
- Sensor status page now configurable.
