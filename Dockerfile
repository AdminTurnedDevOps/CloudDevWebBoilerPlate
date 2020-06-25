FROM mcr.microsoft.com/dotnet/core/sdk AS build-env
WORKDIR /appdir
EXPOSE 80
EXPOSE 443

# Copy csproj and restore as distinct layers
COPY *.csproj /appdir
COPY *CloudDevBoilerPlate.* /appdir/
RUN dotnet restore ./*.csproj

# Copy .NET Core Web App. Release packs the application and its dependencies into a folder for deployment to a hosting system
COPY * ./
RUN dotnet publish ./*.csproj -c Release -o out

# Build the runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet
WORKDIR /appdir
COPY --from=build-env /appdir/out .
ENTRYPOINT ["dotnet", "web.dll"]