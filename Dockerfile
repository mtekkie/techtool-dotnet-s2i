FROM openshift/base-centos7

MAINTAINER Robert Forsström <robert@middleware.se>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="S2I for .net core" \
      io.k8s.display-name="s2i for .net core" \
      io.openshift.tags="builder,dotnet,core"

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label


COPY ./.s2i/ /usr/libexec/s2i

RUN yum -y install libunwind libicu

RUN mkdir -p /dotnet && chmod 777 /usr/libexec/s2i/*  && chmod 777 /dotnet

RUN curl -o /dotnet.tar.gz $dotnetinstallurl

RUN tar xzvf /dotnet.tar.gz -C /dotnet


WORKDIR /dotnet


# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /dotnet

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 5000

# TODO: Set the default CMD for the image
CMD ["usage"]
