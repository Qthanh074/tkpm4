FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 83

# Stage 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["NETCORE2.csproj","src/"]
RUN dotnet restore "src/NETCORE2.csproj"
COPY . .
WORKDIR /src
RUN dotnet build "NETCORE2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NETCORE2.csproj" -c Release -o /app/publish /p:UseAppHost=false


# Stage 2: runtime
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NETCORE2.dll"]
