FROM microsoft/aspnetcore:2.0-nanoserver-1709 AS base
WORKDIR /app
EXPOSE 62077
EXPOSE 44359

FROM microsoft/aspnetcore-build:2.0-nanoserver-1709 AS build
WORKDIR /src
COPY BlogPostApi/BlogPostApi.csproj BlogPostApi/
RUN dotnet restore BlogPostApi/BlogPostApi.csproj
COPY . .
WORKDIR /src/BlogPostApi
RUN dotnet build BlogPostApi.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish BlogPostApi.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "BlogPostApi.dll"]
